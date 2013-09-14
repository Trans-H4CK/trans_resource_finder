class Api::V1::ResourcesController < ApplicationController
  respond_to :json
  def show
    respond_with Resource.find(params[:id])
  end

  def index
    @category_string = params[:category]

    @resources = Resource

    if @category_string
      @category = Category.where(:name => @category_string).first
      if @category
        @resources = @resources.where(:category_id => @category.id)
      else
        @resources = @resources.all
      end
    else
      @resources = @resources.all
    end

    respond_with @resources
  end

  def geocode(zip_code)
    Rails.application.config.geocoder.geocode(:zipcode => zip_code)
  end
end