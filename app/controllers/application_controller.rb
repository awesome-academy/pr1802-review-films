class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private
  def logged_in_user
    return if user_signed_in?
    store_location
    redirect_to login_url, flash: {danger: "Please log in."}
  end
end
