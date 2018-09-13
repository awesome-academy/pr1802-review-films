class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable, dependent: :destroy

  validates_presence_of :content
  validates_length_of :content,
    minimum: Settings.comment.content.length.minimum,
    allow_blank: true

  after_create :add_review_id

  scope :from_review, ->(review) {where review_id: review.id}

  private
  def add_review_id
    if self.commentable.is_a? Review
      self.review_id = self.commentable.id
    else
      self.review_id = self.commentable.review_id
    end
    self.save
  end
end
