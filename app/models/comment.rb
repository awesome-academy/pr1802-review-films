class Comment < ApplicationRecord
  include Nested
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  belongs_to :review, optional: true
  has_many :comments, as: :commentable, dependent: :destroy

  validates_presence_of :content
  validates_length_of :content,
    minimum: Settings.comment.content.length.minimum,
    allow_blank: true

  delegate :name, to: :user, prefix: true

  after_create :add_review_id

  scope :order_created_desc, -> {order created_at: :desc}
  scope :by_users, -> (user_ids) {where("user_id IN (?)", user_ids)}

  def parent_comments
    parent_comments = Array.new
    if commentable.blank? || commentable.is_a?(Review)
      return parent_comments
    end
    parent_comments << commentable
    parent_comments += commentable.parent_comments.to_a
  end

  private
  def add_review_id
    if commentable.is_a? Review
      self.update review_id: commentable.id
    else
      self.update review_id: commentable.review_id
    end
  end
end
