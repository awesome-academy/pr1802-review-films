class CategoriesController < ApplicationController
  def show
    @category = Category.preload(:films).find_by id: params[:id]
    @films = @category.films.preload(:categories)
    @films = @films.filter params

    @sort_prams = I18n.translate :options
    @release_years_list = @films.release_years_list.map &:release_date
    @directors_list = @films.directors_list

    @films = @films.paginate page: params[:page],
      per_page: Settings.films.per_page
  end

  def index
    @categories = Category.all
  end
end
