class ArticlesController < ApplicationController
  def index
    @articles = Article.all.includes(:source)
  end
end
