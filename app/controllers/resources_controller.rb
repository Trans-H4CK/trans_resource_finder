class ResourcesController < ApplicationController

  def index
    @categories = Category.all
  end

	def new
    @resource = Resource.new
	end

  def create
    @resource = Resource.new(params[:resource])

    respond_to do |format|
      if @resource.save
        format.html{redirect_to :back, :notice => "Rating was sucessfully submitted."}

      else
        flash[:error] = @resource.errors.full_messages.to_sentence
        format.html {render :action => "new"}
      end
    end

  end

  def edit
    @resource = Resource.find(params[:id])
  end

  def update
    @resource = Resource.find(params[:id])
    respond_to do |format|
      if @resource.update_attributes(params[:resource])
        format.html{redirect_to :back, :notice => "Resource was sucessfully updated."}
      else
        flash[:error] = @resource.errors.full_messages.to_sentence
        format.html {render :action => "edit"}
      end

    end
  end

  def destroy
    @resource = Resource.find(params[:id])
    @resource.delete
    redirect_to resources_path
  end

end