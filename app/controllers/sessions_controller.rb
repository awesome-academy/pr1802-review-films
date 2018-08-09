class SessionsController < ApplicationController
  def new
  end

  def create
    downcase_email params[:email]
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      log_in user
      params[:remember_me] == "1" ? remember(user) : forget(user)
      redirect_to root_url, flash: { success: "Login Success!" }
    else
      flash.now[:danger] = "Invalid email/password combination!"
      render "new"
    end
  end

  def destroy
    log_out
    redirect_to root_url, flash: { info: "Logout Success!" }
  end

  private

  def downcase_email email
    if email
      email.downcase!
    end
  end
end
