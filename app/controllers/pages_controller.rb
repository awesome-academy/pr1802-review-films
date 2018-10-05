class PagesController < ApplicationController
  def home
    @films = Film.publish
    @slider_films = @films.order_created_desc

    @this_month_films = @films.this_month

    @this_month_reviews = Review.find_by_film_ids(@films.pluck :id).this_month
  end
end
