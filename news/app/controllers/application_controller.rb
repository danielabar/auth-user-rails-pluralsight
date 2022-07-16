class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authorized
  helper_method :current_user
  helper_method :logged_in?

  # Access current user from session at any time
  def current_user
    User.find_by(id: session[:user_id])
  end

  # Determine if user is logged in
  def logged_in?
    !current_user.nil?
  end

  # Force an unauthenticated user to login
  def authorized
    redirect_to '/home/login' unless logged_in?
  end
end
