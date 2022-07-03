class HomeController < ApplicationController
  def index
  end

  def login
    if params["username"]
      user = User.find_by(username: "username")
      @user = user
    end
  end
end
