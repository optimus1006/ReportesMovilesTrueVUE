require 'digest/md5'
class UsersController < ApplicationController  
  layout 'application'
  respond_to :json
  respond_to :html

  def login
  	user = Digest::MD5.hexdigest(params[:user])
  	password = Digest::MD5.hexdigest(params[:password])

  	if user == USERS['login'] && password == USERS['password']
  		session[:current_user] = params[:user]
  		redirect_to reports_path 	
  	else
  		redirect_to root_path(:error => true ) 	
  	end
  	
  end

  def logout
  	session.clear
  	redirect_to root_path 	  	
  end
end
