class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :language

  def language
  	I18n.locale = :es
  end

  def verify_authentication
  	if session[:current_user].nil?
  		redirect_to root_path
  	end
  end
end
