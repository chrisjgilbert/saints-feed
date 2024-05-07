module Scraper
  class LinkExtractor
    private attr_reader :doc, :base_url, :link_selector, :invalid_paths
    def initialize(doc:, base_url:, link_selector:, invalid_paths: [])
      @doc = doc
      @base_url = base_url
      @link_selector = link_selector
      @invalid_paths = invalid_paths
    end

    def call
      doc.search(link_selector).map do |link|
        path = link["href"]

        next if invalid_paths.any? do |pattern|
          path.match?(pattern)
        end

        if path.start_with?(base_url)
          path
        else
          base_url + path
        end
      end.compact.uniq
    end
  end
end
