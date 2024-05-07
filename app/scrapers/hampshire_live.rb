class HampshireLive < Base
  def source_name
    "Hampshire Live"
  end

  def index_url
    "https://www.hampshirelive.news/all-about/southampton-fc"
  end

  def valid_paths
    [
      /\/sport\/football\/football-news\/[a-zA-Z0-9-]+-\d+$/
    ]
  end
end
