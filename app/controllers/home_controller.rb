
class HomeController < ApplicationController
  layout 'application'
  respond_to :json
  respond_to :html

  def index
  	@error = nil
  	unless session[:current_user].nil?
  		redirect_to reports_path
  	end
  	unless params[:error].nil?
  		@error = I18n.t('errors.login')
  	end
  end
end
