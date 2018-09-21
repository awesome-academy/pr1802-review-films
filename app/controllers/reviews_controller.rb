class ReviewsController < ApplicationController
  before_action :find_review, only: :show

  def index
    @reviews = Review.paginate page: params[:page],
      per_page: Settings.reviews.per_page
  end

  def show
  end

  private
  def find_review
    @review = Review.includes(:comments).find_by film_id: params[:film_id]
  end
end
