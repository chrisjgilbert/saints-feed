class Article < ApplicationRecord
  belongs_to :source

  validates :url, presence: true, uniqueness: true
  validates :title, presence: true
  validates :source, presence: true
  validates :published_at, presence: true
end
