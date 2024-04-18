class Source < ApplicationRecord
  has_many :articles, dependent: :destroy

  validates :name, presence: true

  # TODO: brittle
  def logo_path
    "sources/#{name.parameterize(separator: "_")}.png"
  end
end
