class Person < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :imdb_id

  scope :order_name_asc, -> {order name: :asc}
end
