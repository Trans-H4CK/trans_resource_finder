class Api::V1::ResourcesController < ApplicationController
  respond_to :json
  def show
    respond_with Resource.find(params[:id])
  end

  def index
    @category_string = params[:category]

    if @category_string
      @category = Category.where(:name => @category_string).first
      @resources = Resource.where(:category_id => @category.id)
    else
      @resources = Resource.all
    end

    respond_with @resources
  end

  def geocode(zip_code)
    Rails.application.config.geocoder.geocode(:zipcode => zip_code)
  end
end