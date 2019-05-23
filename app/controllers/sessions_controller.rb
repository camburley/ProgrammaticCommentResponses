class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(auth)
    session[:user_id] = user.id

    redirect_to admin_path
  end
  
  def destroy
      session[:user_id] = nil
      redirect_to root_path
  end

  protected
  	def auth
  		request.env['omniauth.auth']
  	end
end