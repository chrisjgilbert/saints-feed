class DailyEcho < Base
  def source_name
    "Daily Echo"
  end

  def index_url
    "https://www.dailyecho.co.uk/sport/saints"
  end

  def valid_paths
    [
      /\/sport\/\d+\.[a-zA-Z0-9-]+\/$/
    ]
  end
end
