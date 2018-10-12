require "mechanize"
require "uri"

role_actor = Role.create! name: "Actor"
role_director = Role.create! name: "Director"

User.create!(
  name:  "123",
  email: "123@123.com",
  password: "123123",
  password_confirmation: "123123",
  admin: true
)

5.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@domain.com"
  password = "password"
  User.create!(
    name:  name,
    email: email,
    password: password,
    password_confirmation: password
  )
end

# Crawling movies
BASE_URL = "https://www.imdb.com/chart/top"
ROOT_URL = "https://www.imdb.com"
url = BASE_URL
agent = Mechanize.new
page = agent.get url
page.search(".titleColumn a").first(100).each do |link|
  movie_url = ROOT_URL + link.attributes["href"].try(:value)
  crawled_movie_imdb_id = URI::parse(movie_url).path.split("/").last
    .gsub(/\D/, '')
  crawled_page = agent.get movie_url
  crawled_name = crawled_page.at("h1").children.first.text
    .gsub!(/[^0-9A-Za-z ]/, '')
  crawled_introduction = crawled_page.at("#titleStoryLine p span")
    .try(:text).strip
  crawled_release_date = crawled_page.at("#titleDetails")
    .search(".txt-block:contains('Release Date:')").at("h4")
    .next_sibling.text.to_date
  crawled_country = crawled_page.at("#titleDetails")
    .search(".txt-block:contains('Country:')").at("h4")
    .next_sibling.next_sibling.text.strip
  crawled_duration = crawled_page
    .at("#title-overview-widget .title_wrapper time")
    .attributes["datetime"].value.strip.gsub(/\D/, '')
  crawled_directors = crawled_page
    .search(".credit_summary_item:contains('Director') a")
  crawled_actors = crawled_page
    .search(".credit_summary_item:contains('Stars') a")[0...-1]
  crawled_categories = crawled_page.at("#titleStoryLine")
    .search(".inline:contains('Genre') a").text.strip.split(" ").to_a
  crawled_review_title = crawled_page.search(".user-comments strong").text
  crawled_review = crawled_page.search(".user-comments p").to_html

  user = User.first

  film = user.films.create!(
    name: crawled_name,
    introduction: crawled_introduction,
    trailer: "https://www.youtube.com/watch?v=Z1BCujX3pw8",
    release_date: crawled_release_date,
    duration: crawled_duration,
    country: crawled_country,
    imdb_id: crawled_movie_imdb_id
  )

  crawled_categories.each do |category|
    FilmCategory.create(
      film: film,
      category: Category.find_or_create_by(name: category)
    )
  end

  crawled_directors.each do |crawled_director|
    film.film_roles.create!(
      role: role_director,
      person: Person.find_or_create_by(
        name: crawled_director.text,
        imdb_id: URI::parse(ROOT_URL + crawled_director.attributes["href"].value).path.split("/").last.gsub(/\D/, '')
      )
    )
  end

  crawled_actors.each do |crawled_actor|
    film.film_roles.create!(
      role: role_actor,
      person: Person.find_or_create_by(
        name: crawled_actor.text,
        imdb_id: URI::parse(ROOT_URL + crawled_actor.attributes["href"].value).path.split("/").last.gsub(/\D/, '')
      )
    )
  end

  film.create_review(
    user: User.first,
    title: crawled_review_title,
    content: crawled_review
  )
end
