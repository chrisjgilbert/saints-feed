require "nokogiri"
require "open-uri"
require "watir"

module Scrapers
  class HampshireLive
    BASE_URL = "https://www.hampshirelive.news"
    LANDING_URL = "#{BASE_URL}/all-about/southampton-fc"
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
        title = article.xpath("//meta[@property='og:title']/@content").text
        description = article.xpath("//meta[@property='og:description']/@content").text
        image_path = article.xpath("//meta[@property='og:image']/@content").text
        published_at = DateTime.now

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

    # private

    def landing_page
      get_doc(LANDING_URL)
    end

    def article_urls
      get_doc(LANDING_URL)
        .search("a.headline")
        .uniq
        .map { |a| a["href"] }
    end

    def get_doc(url)
      Nokogiri::HTML(URI.open(url))
    end
  end
end
