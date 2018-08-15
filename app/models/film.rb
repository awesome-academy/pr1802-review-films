class Film < ApplicationRecord
  belongs_to :user
  has_one :review
  has_many :ratings
  has_many :raters, through: :ratings, source: :user
  has_many :film_categories
  has_many :categories, through: :film_categories

  validates :name, presence: true

  mount_uploader :thumbnail, ThumbnailUploader
  mount_uploader :poster, ThumbnailUploader
  mount_uploader :video_thumbnail, ThumbnailUploader
end
