class User < ApplicationRecord
  has_many :films
  has_many :comments
  has_many :ratings
  has_many :rated_films, through: :ratings, source: :film
  has_many :reviews

  attr_accessor :remember_token
  before_save :downcase_email

  validates :name, presence: true, length: {minimum: 3}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 50},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}

  validates :password, presence: true, length: {minimum: 6}, allow_nil: true
  has_secure_password

  def downcase_email
    self.email = email.downcase
  end

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
end
