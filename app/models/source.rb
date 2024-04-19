class Source < ApplicationRecord
  has_many :articles, dependent: :destroy

  validates :name, presence: true

  def logo_path
    "sources/#{name.parameterize(separator: "_")}.png"
  end

  def pull_articles
    scraper.call
  end

  def scraper
    @scraper ||= Scrapers.const_get(name.delete(" ").classify).new(self)
  end
end
