class HomeController < ApplicationController
  skip_before_action :authorized, only: [:login, :logout, :index]

  def index
  end

  def login
    if params["username"]
      user = User.find_by(username: params[:username])
      @valid = user.authenticate(params[:password])
      if @valid
        puts("=== authentication successful for #{user.username}, populating session with #{user.id}")
        session[:user_id] = user.id
        redirect_to '/'
      else
        puts("=== authentication failed for #{user.username}")
      end
    end
  end

  def logout
    session[:user_id] = nil
  end
end
