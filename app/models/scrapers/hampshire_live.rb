require "nokogiri"
require "open-uri"
require "watir"

module Scrapers
  class HampshireLive < Base
    def source_name
      "Hampshire Live"
    end

    def base_url
      "https://www.hampshirelive.news"
    end

    def index_path
      "/all-about/southampton-fc"
    end

    def article_url_selector
      "a.headline"
    end
  end
end
