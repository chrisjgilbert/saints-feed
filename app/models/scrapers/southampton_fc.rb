require "nokogiri"
require "open-uri"
require "watir"

module Scrapers
  class SouthamptonFC
    BASE_URL = "https://www.southamptonfc.com"
    LANDING_URL = "#{BASE_URL}/en/news/latest-news"
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
        title = CGI.unescapeHTML(article.fetch("headline"))
        description = CGI.unescapeHTML(article.fetch("description"))
        image_path = article.fetch("image")
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

    def landing_page
      get_doc(LANDING_URL)
    end

    def article_urls
      browser = Watir::Browser.new(:chrome, headless: true)
      browser.goto(LANDING_URL)
      browser.element(css: ".news-list").wait_until(&:present?)
      doc = Nokogiri::HTML(browser.html)
      doc.search(".article-card__floating-link").map { |link| CGI.unescape("#{BASE_URL}#{link["href"]}") }
    end

    def get_doc(url)
      Nokogiri::HTML(URI.open(url))
    end
  end
end
