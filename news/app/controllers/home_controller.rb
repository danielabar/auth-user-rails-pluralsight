class HomeController < ApplicationController
  def index
  end

  def login
    if params["username"]
      user = User.find_by(username: params[:username])
      @valid = user.authenticate(params[:password])
      puts("=== LOGIN @valid = #{@valid}")
    end
  end
end
