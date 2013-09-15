class Api::V1::ResourcesController < ApplicationController
  layout :false

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

    @per_page = params[:per_page].try(:to_i) || 10
    @resources = @resources.paginate(:page => params[:page], :per_page => 10)

  end

end