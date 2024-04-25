require "nokogiri"
require "open-uri"
require "watir"

module Scrapers
  class SouthamptonFC
    def self.call
      new(Source.find_by(name: "Southampton FC")).call
    end

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

        begin
          article_doc = ArticleParser.from_url(url)
          source.articles.create!(
            url: url,
            title: article_doc.title,
            description: article_doc.description,
            image_path: article_doc.image_path,
            published_at: article_doc.published_at
          )
        rescue ActiveRecord::RecordInvalid => e
          Rails.logger.error "Error creating article: #{e.message}"
          @errors += 1
          next
        end

        @created_articles += 1
        sleep 0.5
      end

      Rails.logger.info output_message
    end

    private

    def output_message
      %(
      *****************************************
      Created #{@created_articles} articles.
      Ignored #{@duplicate_articles} duplicates.
      There were #{@errors} errors.
      *****************************************
    )
    end

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
