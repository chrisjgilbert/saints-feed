class Base
  def self.run!
    new.run!
  end

  def initialize
    @created_articles = 0
    @duplicate_articles = 0
    @errors = 0
  end

  def source_name
    raise NotImplementedError
  end

  def index_url
    raise NotImplementedError
  end

  def valid_paths
    raise NotImplementedError
  end

  def source
    @source ||= Source.find_by(name: source_name)
  end

  def run!
    article_urls = driver.find_valid_urls(index_url, valid_paths)

    article_urls.each do |url|
      if source.articles.exists?(url: url)
        @duplicate_articles += 1
        next
      end

      article_attrs = driver.find_article_attrs(url)
      begin
        source.articles.create!(url: url, **article_attrs)
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error("Error creating article: #{e.message}")
        @errors += 1
        next
      ensure
        sleep 0.5
      end

      @created_articles += 1
    end

    Rails.logger.info(output_message)
  end

  private

  def driver
    @driver ||= Driver.new
  end

  def output_message
    %(
      *****************************************
      Created #{@created_articles} articles.
      Ignored #{@duplicate_articles} duplicates.
      There were #{@errors} errors.
      *****************************************
    )
  end
end
