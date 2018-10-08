class Film < ApplicationRecord
  include Filter

  belongs_to :user
  has_one :review, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user, dependent: :destroy
  has_many :film_categories, dependent: :destroy
  has_many :categories, through: :film_categories, dependent: :destroy
  has_many :film_roles, dependent: :destroy
  has_many :people, through: :film_roles

  has_many :actors, -> {where "film_roles.role_id = ?", Role.actor_id},
    class_name: "Person", through: :film_roles, source: :person
  has_many :directors, -> {where "film_roles.role_id = ?", Role.director_id},
    class_name: "Person", through: :film_roles, source: :person

  enum status: {publish: 1, pending: 0}

  validates :name, presence: true
  validates_uniqueness_of :imdb_id

  mount_uploader :thumbnail, ThumbnailUploader
  mount_uploader :poster, ThumbnailUploader
  mount_uploader :video_thumbnail, ThumbnailUploader

  scope :order_created_desc, -> {order created_at: :desc}

  scope :order_released_desc, -> {order release_date: :desc}

  scope :related_films, -> (film) do
    joins(:film_categories).where("category_id IN (?)", film.category_ids)
      .where.not(id: film.id).distinct.limit Settings.films.related_limit
  end

  scope :this_month, -> do
    where("month(release_date) like ?", Time.now.month)
  end

  scope :recently_released, -> do
    where("release_date < ?", Time.now).limit Settings.films.spotlight_limit
  end

  scope :top_rated, -> do
    order(average_ratings: :desc).limit Settings.films.spotlight_limit
  end

  scope :coming_soon, -> do
    where("release_date > ?", Time.now).order(release_date: :asc)
      .limit Settings.films.spotlight_limit
  end

  scope :filter_by_role, ->(role_id) do
    joins(:film_roles).where("film_roles.role_id = ?", role_id)
  end

  scope :search_people, ->(person_name) do
    joins(:people).where("people.name like ?", "%#{person_name}%").distinct
  end

  scope :search_with_option, ->(search_option, search_content) do
    case search_option
    when "name"
      where "name like ?","%#{search_content}%"
    when "actors"
      filter_by_role(Role.actor_id).search_people(search_content)
    when "directors"
      filter_by_role(Role.director_id).search_people(search_content)
    end
  end

  scope :search_all, -> (search_content) do
    joins(:film_roles).joins(:people)
      .where("people.name like ? OR films.name like ?",
             "%#{search_content}%", "%#{search_content}%")
      .distinct
  end

  scope :search_in_cat, ->(search_params) do
    where "films.name like ?", "%#{search_params}%"
  end

  scope :sort_films, ->(sort_params){order("#{sort_params}")}

  scope :release_years_list, -> do
    select("year(release_date) as release_date")
      .where("release_date is not null")
      .distinct("release_date")
      .order "release_date asc"
  end

  scope :filter_by_year, ->(year_params) do
    where "year(release_date) = ?", "#{year_params}"
  end

  scope :directors_list, -> do
    filter_by_role(Role.director_id).joins(:people).distinct
      .pluck("people.name, people.id")
  end

  scope :filter_by_director, ->(director_params) do
    filter_by_role(Role.director_id).joins(:people).distinct
      .where("people.id = ?", director_params)
  end

  scope :filter_by_interval, ->(start_date, end_date) do
    where("release_date between ? and ?", "#{start_date}", "#{end_date}")
      .distinct "release_date"
  end

  def self.to_csv options = {}
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |film|
        csv << film.attributes.values_at(*column_names)
      end
    end
  end

  def actor_ids=(new_actor_ids)
    return unless new_actor_ids.is_a? Array
    unless (create_ids = new_actor_ids - self.actor_ids) == []
      create_ids.each do |create_id|
        FilmRole.create!(
          film_id: id,
          role_id: Role.actor_id,
          person_id: create_id
        ) if create_id.present?
      end
    end

    unless (destroy_ids = self.actor_ids - new_actor_ids) == []
      destroy_ids.each do |destroy_id|
        FilmRole.find_by(
          film_id: id,
          role_id: Role.actor_id,
          person_id: destroy_id
        ).destroy if destroy_id.present?
      end
    end
  end

  def director_ids=(new_director_ids)
    return unless new_director_ids.is_a? Array
    unless (create_ids = new_director_ids - self.director_ids)  == []
      create_ids.each do |create_id|
        FilmRole.create!(
          film_id: id,
          role_id: Role.director_id,
          person_id: create_id
        ) if create_id.present?
      end
    end

    unless (destroy_ids = self.director_ids - new_director_ids) == []
      destroy_ids.each do |destroy_id|
        FilmRole.find_by(
          film_id: id,
          role_id: Role.director_id,
          person_id: destroy_id
        ).destroy if destroy_id.present?
      end
    end
  end
end
