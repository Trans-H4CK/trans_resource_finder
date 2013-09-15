class Api::V1::CategoriesController < ApiController

  def index
    @categories = Category.all
    respond_with @categories
  end

end