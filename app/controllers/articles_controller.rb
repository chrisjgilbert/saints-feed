class ArticlesController < ApplicationController
  def index
    @articles = Article.order(published_at: :desc).all.includes(:source)
  end
end
