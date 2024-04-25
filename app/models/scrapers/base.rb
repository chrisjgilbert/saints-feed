require "nokogiri"
require "open-uri"
require "watir"

module Scrapers
  class Base
    def initialize
      @created_articles = 0
      @duplicate_articles = 0
      @errors = 0
    end

    def source
      @source ||= Source.find_by(name: source_name)
    end

    def set_source
      raise NotImplementedError
    end

    def base_url
      raise NotImplementedError
    end

    def index_path
      raise NotImplementedError
    end

    def article_url_selector
      raise NotImplementedError
    end

    def skip_article_url_patterns
      []
    end

    def article_urls
      urls = index_doc.search(article_url_selector).map do |link|
        path = link["href"]

        next if skip_article_urls_patterns.any? do |pattern|
          link["href"].match?(pattern)
        end

        if path.start_with?(base_url)
          path
        else
          base_url + path
        end
      end
      urls.compact.uniq
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

    def index_url
      base_url + index_path
    end

    def index_doc
      get_doc(index_url)
    end

    def get_doc(url)
      Nokogiri::HTML(URI.open(url))
    end
  end
end
