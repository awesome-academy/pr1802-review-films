class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.string :name
      t.integer :imdb_id, index: true

      t.timestamps
    end
  end
end
