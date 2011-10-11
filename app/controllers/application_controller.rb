class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_for_profile
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
  def check_for_profile
    if request.env['PATH_INFO'] != '/profile/edit' and request.env['PATH_INFO'] != '/profiles'
      if user_signed_in?
        if not current_user.profile.present?
          redirect_to '/profile/edit', notice: 'Please take a moment to create your profile.'
        end
      end
    end
  end
end
