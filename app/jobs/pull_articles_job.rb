class PullArticlesJob < ApplicationJob
  queue_as :default

  def perform(source_id)
  end
end
