class Admin::FilmsController < AdminController
  before_action :find_film, only: [:edit, :update, :show, :destroy]
  def index
    @films = Film.paginate page: params[:page], per_page: 20
    @films = @films.order_films
  end

  def show
  end

  def new
    @film = Film.new
  end

  def create
    @film = current_user.films.new film_params
    if @film.save
      flash[:info] = t ".film_created"
      redirect_to admin_films_path
    else
      flash[:alert] = t ".film_created_error"
      render :new
    end
  end

  def edit
  end

  def update
    if @film.update film_params
      flash[:alert] = t ".film_updated"
      redirect_to admin_films_path
    else
      flash[:alert] = t ".film_updated_error"
      render :edit
    end
  end

  def destroy
    @film.destroy
    redirect_to admin_films_path
  end

  private

  def film_params
    params.require(:film).permit(:name, :introduction, :poster,
      :poster_cache, :thumbnail, :thumbnail_cache, :trailer, :video_thumbnail,
      :video_thumbnail_cache, :actors, :directors, :country, :release_date,
      :duration, category_ids: [])
  end

  def find_film
    @film = Film.find_by id: params[:id]
  end
end
