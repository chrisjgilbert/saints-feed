require "open-uri"

class PullArticlesJob < ApplicationJob
  queue_as :default

  def perform(source_id)
    sources = Source.all
    sources.each(&:get_articles)
  end
end
