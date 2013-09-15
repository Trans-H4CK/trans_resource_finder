class ApiController < ActionController::Base
  protect_from_forgery

  layout :false
  respond_to :json
end