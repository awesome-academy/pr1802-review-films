class FilmsController < ApplicationController
  before_action :find_film, only: :show

  def show
    @rate = @film.ratings.build
  end

  private

  def find_film
    @film = Film.find_by id: params[:id]
  end
end
