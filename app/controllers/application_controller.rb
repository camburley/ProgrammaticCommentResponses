class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :current_page

  def authenticate
  	redirect_to login_path(:facebook) unless !!current_user
  end

  def page_selected
    redirect_to admin_settings_path unless !!current_page
  end

  def current_user
  	@current_user ||= User.find_by(id: session[:user_id]) if session[:user_id] && User.find_by(id: session[:user_id])
  end

  def current_page
    @current_page ||= Page.find(current_user.page_selected) if current_user && current_user.page_selected
  end
end
