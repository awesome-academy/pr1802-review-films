class AdminController < ApplicationController
  before_action :authenticated_user!
  layout "admin"

  private
  def authenticated_user!
    unless user_signed_in?
      redirect_to login_url, flash: { info: "Please login!" }
      return
    end
    redirect_to root_url, flash: { danger: "Unauthorized!" } \
      unless current_user.admin?
  end
end
