class ReviewsController < ApplicationController
  before_action :find_review, only: :show

  def show
    @all_comments = Comment.from_review(@review)
  end

  private

  def find_review
    @review = Review.find_by id: params[:id]
  end
end
