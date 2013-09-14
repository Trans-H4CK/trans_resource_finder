class ResourcesController < ApplicationController

	def new
    @resource = Resource.new
	end

  def create
    @resource = Resource.new(params[:resouce])

    respond_to do |format|
      if @resource.save
        format.html{redirect_to :back, :notice => "Rating was sucessfully submitted."}

      else
        flash[:error] = @resource.error.full_message.to_sentence
        format.html {render :action => "new"}
      end
    end

  end


end