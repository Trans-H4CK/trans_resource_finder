class Api::V1::ResourcesController < ApplicationController
  respond_to :json
  def show
    respond_with Resource.find(params[:id])
  end
end