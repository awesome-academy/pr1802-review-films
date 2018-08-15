class RatingsController < ApplicationController
  before_action :logged_in_user, only: :create
  
  def create
    @rate = Rating.new(rate_params)
    if @rate.save
      flash[:info] = "rate created !"
      redirect_to film_path @rate.film_id
    else
      flash[:alert] = "rate creating error !"
      render "films/show"
    end
  end

  private

  def rate_params
    params.require(:rating).permit(:rate, :film_id).merge(user_id: current_user.id)
  end
end
