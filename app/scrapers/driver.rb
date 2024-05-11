class Driver
  private attr_reader :driver

  def initialize
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument("--headless")
    options.addArguments("--no-sandbox");
    options.addArguments("--disable-dev-shm-usage")
  end

  def find_valid_urls(url, valid_paths = [])
    navigate_to(url)
    links = driver.find_elements(tag_name: "a")
    hrefs = links.filter_map { |link| link.attribute("href") }
    valid_hrefs = hrefs.select { |href| href.match?(Regexp.union(valid_paths)) }
    valid_hrefs.uniq
  end

  def find_article_attrs(url)
    navigate_to(url)
    article = ArticleParser.new(driver.page_source)
    article.attrs
  end

  private

  def navigate_to(url)
    driver.navigate.to(url)
  end
end
