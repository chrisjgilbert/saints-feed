require "nokogiri"
require "open-uri"

module Scrapers
  class DailyEcho < Base
    def source_name
      "Daily Echo"
    end

    def base_url
      "https://www.dailyecho.co.uk"
    end

    def index_path
      "/sport/saints"
    end

    def article_url_selector
      "article a"
    end

    def skip_article_url_patterns
      [
        /\#comments-anchor\Z/,
        /^\/topics\/southampton-fc$/
      ]
    end
  end
end
