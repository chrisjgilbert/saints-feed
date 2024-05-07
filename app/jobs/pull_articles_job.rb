class PullArticlesJob < ApplicationJob
  queue_as :default

  def perform(scraper)
    scraper.run!
  end
end
