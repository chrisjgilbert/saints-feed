class ArticleParser
  private attr_reader :doc
  def initialize(html)
    @doc = Nokogiri::HTML(html)
  end

  def attrs
    {
      title: title,
      description: description,
      image_path: image_path,
      published_at: published_at
    }
  end

  def title
    schema["headline"] || meta_title
  end

  def description
    schema["description"] || meta_description
  end

  def image_path
    schema_image_path = if schema["image"].is_a?(Hash)
      schema["image"]["url"]
    else
      schema["image"]
    end

    schema_image_path || meta_image_path
  end

  def published_at
    schema["datePublished"] || DateTime.now
  end

  def meta_title
    doc.xpath("//meta[@property='og:title']/@content").text
  end

  def meta_description
    doc.xpath("//meta[@property='og:description']/@content").text
  end

  def meta_image_path
    doc.xpath("//meta[@property='og:image']/@content").text
  end

  def schema
    JSON.parse(doc.search("script[type='application/ld+json']").text)
  rescue JSON::ParserError
    {}
  end
end
