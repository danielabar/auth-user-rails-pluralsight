class ResetMailer < ApplicationMailer
  def reset_password
    @user = params[:user]
    @url = "#{password_reset_url}?token=#{params[:token]}"
    mail(to: @user.email, subject: 'Reset Password for News App')
  end
end
