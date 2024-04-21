require "nokogiri"
require "open-uri"

module Scrapers
  class DailyEcho
    BASE_URL = "https://www.dailyecho.co.uk"
    LANDING_URL = "#{BASE_URL}/sport/saints"
    private attr_reader :source

    def initialize(source)
      @source = source
      @created_articles = 0
      @duplicate_articles = 0
      @errors = 0
    end

    def call
      article_urls.each do |url|
        if source.articles.exists?(url: url)
          @duplicate_articles += 1
          next
        end

        article = get_doc(url)
        article = JSON.parse(article.search("script[type='application/ld+json']").text)
        title = article.fetch("headline")
        description = article.fetch("description", "")
        image_path = article.fetch("image").fetch("url")
        published_at = DateTime.parse(article.fetch("datePublished"))

        source.articles.create!(
          url: url,
          title: title,
          description: description,
          image_path: image_path,
          published_at: published_at
        )
      rescue JSON::ParserError => e
        Rails.logger.error "Error parsing schema at #{url}: #{e.message}"
        next
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error "Error creating article: #{e.message}"
        @errors += 1
        next

        @created_articles += 1

        sleep 0.5

        Rails.logger.info %(
          *****************************************
          Created #{@created_articles} articles.
          Ignored #{@duplicate_articles} duplicates.
          There were #{@errors} errors.
          *****************************************
        )
      end
    end

    private

    def article_urls
      get_doc(LANDING_URL)
        .xpath("//article//a/@href")
        .map(&:value)
        .reject { |path| path.include?("#comments-anchor") } # Use xpath?
        .uniq
        .map { |path| CGI.unescape("#{BASE_URL}#{path}") }
    end

    def get_doc(url)
      Nokogiri::HTML(URI.open(url))
    end
  end
end
