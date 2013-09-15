class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_social_media_profiles

  def set_social_media_profiles
    @social_media_profiles = SocialMediaProfile.all
  end
end
