class PullDailyEchoArticlesJob < ApplicationJob
  queue_as :default

  def perform
    DailyEcho.run!
  end
end
