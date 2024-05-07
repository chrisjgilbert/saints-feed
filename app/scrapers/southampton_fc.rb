class SouthamptonFC < Base
  def source_name
    "Southampton FC"
  end

  def index_url
    "https://www.southamptonfc.com/en/news/latest-news"
  end

  def valid_paths
    [
      /\/en\/news\/article\/[a-zA-Z0-9-]+/
    ]
  end
end
