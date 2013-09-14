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
      end
    end

    @zip_code = params[:zip_code].try(:to_i)
    if @zip_code
      @resources = RangeQuery.new(@resources).with_range_from(@zip_code)
      @resources = @resources.order('range ASC')
    else
      @resources = @resources.order('name ASC')
    end

    respond_with @resources
  end

end