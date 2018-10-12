class AddImdbIdToFilm < ActiveRecord::Migration[5.2]
  def change
    add_column :films, :imdb_id, :integer, index: true
  end
end
