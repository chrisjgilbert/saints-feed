class PullSouthamptonFCArticlesJob < ApplicationJob
  queue_as :default

  def perform
    source = Source.find_by(name: "Southampton FC")
    config = {
      base_url: "https://www.southamptonfc.com",
      article_index_path: "/en/news/latest-news",
      index_article_link_selector: ".article-card__floating-link",
      index_javascript_wait_selector: ".news-list"
    }

    Scraper.call(source, config)
  end
end
