class Article < ApplicationRecord
  belongs_to :source

  validates :url, presence: true, uniqueness: true
  validates :title, presence: true
end
