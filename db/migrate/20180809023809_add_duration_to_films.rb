class AddDurationToFilms < ActiveRecord::Migration[5.2]
  def change
    add_column :films, :duration, :decimal
  end
end
