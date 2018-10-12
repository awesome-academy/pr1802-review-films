class CreateFilmRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :film_roles do |t|
      t.references :film, foreign_key: true
      t.references :role, foreign_key: true
      t.references :person, foreign_key: true

      t.timestamps
    end
  end
end
