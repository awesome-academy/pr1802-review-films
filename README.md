# PR1802 Review Films

This is a site for browsing movies and reviews.

Porject members: Duy, Dũng, Thơ.

## Features
  - Home page with a movies slider, recent movies and reviews blocks.
  - Navigating by movies genres.
  - Searching for movies, actors and directors.
  - Login/Signup via email address.
  - Comment on reviews, infinite reply to others.
  - Managing users, films, genres and reviews within a separate admin panel ("/admin").
  - Multiple language capable.

## Specs requirement
This project was developed and tested on:
  - Ruby >= 2.4
  - Ruby on Rails 5.2
  - Mysql 5.7
  - NodeJS stable (>= 8 recommended)

## Deploy (development environment)
  - Clone the project
  - Copy config/database.yml.template to config/database.yml, replace your database name, database username and password.
  - Copy .env.template to .env, replace your email address, username and password (for password reset feature).
  - rails db:create if database was not existed (with database user having database create privileges).
  - rails db:migrate for creating database tables.
  - rails db:seeds for crawling data from imdb (top 100 from 250 chart).
  - Login with default username and password: "123@123.com"/"123123" (defined in db/seeds.rb file).
