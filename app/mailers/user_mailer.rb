class UserMailer < ApplicationMailer
  default from: ENV['email_from']

  def password_reset user
    @user = user
    mail to: user.email, subject: t(".subject")
  end
end
