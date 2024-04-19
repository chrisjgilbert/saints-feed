module Scrapers
  class SouthamptonFC
    BASE_URL = "https://www.southamptonfc.com"
    LANDING_URL = "#{BASE_URL}/en/news"
    private attr_reader :source
    def initialize(source)
      @source = source
    end

    def call
      landing_page_article_paths.each do |path|
        next if source.articles.exists?(url: path)

        article = get("#{BASE_URL}#{path}")
        title = article.xpath("//meta[@property='og:title']/@content").first.value
        description = article.xpath("//meta[@property='og:description']/@content").first.value
        image_path = article.xpath("//meta[@property='og:image']/@content").first.value

        source.articles.create!(url: path, title: title, description: description, image_path: image_path)

        sleep 0.5
      end
    end

    def landing_page_article_paths
      get(LANDING_URL).xpath('// * [@id = "splide01-slide01//a/@href"]').map(&:value)
    end

    def get(url)
      Nokogiri::HTML(URI.open(url))
    end
  end
end
