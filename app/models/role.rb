class Role < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :name, allow_blank: true

  scope :actor_id, -> {find_by(name: "Actor").id}
  scope :director_id, -> {find_by(name: "Director").id}
end
