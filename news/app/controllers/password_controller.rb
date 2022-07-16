class PasswordController < ApplicationController
  def reset
    token = request.query_parameters[:token] || params[:token] || not_found
    @user = User.find_by(reset: token) or not_found
    if params[:password]
      @user.password = params[:password]
      @user.reset = nil
      @user.save
      render plain: "Successfully reset password."
    end
  end

  def forgot
    if params[:email]
      # Update user with a reset token
      user = User.find_by(email: params[:email]) or not_found
      token = SecureRandom.hex(10)
      user.reset = token
      user.save

      # Email token to user
      ResetMailer.with(user: user, token: token).reset_password.deliver_now

      # A simple response to browser
      render plain: "A link to reset your password has been sent to that email if it exists. "
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
