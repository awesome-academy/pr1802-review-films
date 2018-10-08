class RemoveActorsAndDirectorsFromFilm < ActiveRecord::Migration[5.2]
  def change
    remove_column :films, :directors, :string
    remove_column :films, :actors, :string
  end
end
