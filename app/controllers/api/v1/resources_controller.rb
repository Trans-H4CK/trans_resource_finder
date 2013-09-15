class Api::V1::ResourcesController < ApiController

  def show
    respond_with Resource.find(params[:id])
  end

  def index
    resource_search = ResourceSearch.new(params)
    @resources = resource_search.matches

    respond_with @resources
  end

end