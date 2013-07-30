class ApplicationController < ActionController::Base
  protect_from_forgery

  def verify_authentication
  	if session[:current_user].nil?
  		redirect_to root_path
  	end
  end
end
