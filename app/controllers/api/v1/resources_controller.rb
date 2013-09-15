class Api::V1::ResourcesController < ApplicationController
  layout :false

  respond_to :json
  def show
    respond_with Resource.find(params[:id])
  end

  def index
    resource_search = ResourceSearch.new(params)
    @resources = resource_search.matches

    respond_with @resources
  end

end