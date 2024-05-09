class PullArticlesJob < ApplicationJob
  queue_as :default

  def perform(scraper)
    scraper = Scrapers.lookup(scraper)
    scraper.run!
  end
end
