class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:destroy]
  before_action :find_commentable
  before_action :find_comment, only: [:index, :destroy]

  def index
    @comments = @commentable.comments
    respond_to do |format|
      format.js
    end
  end

  def create
    @comment = @commentable.comments
      .build comment_params.merge user_id: current_user.id
    if @comment.save
      respond_to do |format|
        format.html do
          flash[:success] = t ".comment_create"
          redirect_back fallback_location: root_path
        end
        format.js
      end
    else
      respond_to do |format|
        format.html do
          flash[:danger] = @comment.errors.full_messages
          redirect_back fallback_location: root_path
        end
        format.js
      end
    end
  end

  def destroy
    if @comment.destroy
      respond_to do |format|
        format.html do
          flash[:success] = t ".comment_destroy"
          redirect_back fallback_location: root_path
        end
        format.js
      end
    else
      respond_to do |format|
        format.html do
          flash[:danger] = @comment.errors.full_messages
          redirect_back fallback_location: root_path
        end
        format.js
      end
    end
  end

  private
  def comment_params
    params.require(:comment).permit :content
  end

  def find_commentable
    @commentable = case
      when params[:review_id]
        Review.find_by_id params[:review_id]
      when params[:comment_id]
        Comment.find_by_id params[:comment_id]
      end
  end

  def find_comment
    @comment = Comment.find_by id: params[:id]
  end
end
