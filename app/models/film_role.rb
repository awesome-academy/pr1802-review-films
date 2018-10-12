class FilmRole < ApplicationRecord
  belongs_to :film
  belongs_to :role
  belongs_to :person
end
