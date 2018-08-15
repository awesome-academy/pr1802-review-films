class Admin::ReviewsController < AdminController
  before_action :find_review, only: [:show, :edit, :update, :destroy]
  before_action :find_film, only: [:new, :create]

  def index
    @reviews = Review.paginate page: params[:page], per_page: 20
  end

  def show
  end

  def new
    @review = @film.build_review
  end

  def create
    @review = @film.build_review review_params.merge(user_id: current_user.id)
    if @review.save
      flash[:info] = "Review created success!"
      redirect_to admin_review_path @review
    else
      flash[:danger] = "Review creating has errors!"
      render :new
    end
  end

  def edit
  end

  def update
    if @review.update review_params
      flash[:info] = "Review updated success!"
      redirect_to admin_review_path @review
    else
      flash[:danger] = "Review updating has errors!"
      render :edit
    end
  end

  def destroy
    @review.destroy
    redirect_to admin_film_path @review.film
  end

  private

  def review_params
    params.require(:review).permit(:title, :content)
  end

  def find_review
    @review = Review.find_by id: params[:id]
  end

  def find_film
    @film = Film.find_by id: params[:film_id]
  end
end
