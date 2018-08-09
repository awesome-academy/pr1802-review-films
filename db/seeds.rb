User.create!(name:  "123",
             email: "123@123.com",
             password:              "123123",
             password_confirmation: "123123",
             admin: true,
            )

30.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@domain.com"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end

users = User.order(:created_at).take(6)

10.times do
  name = Faker::Lorem.sentence(1)
  users.each { |user| user.films.create!(name: name) }
end
users = User.order(:created_at).take(6)
films = Film.all.take(6)

users.zip(films).each do |user, film|
  film.create_review!(title: Faker::Lorem.sentence(1),
                    content: Faker::Lorem.paragraph(5),
                    user_id: user.id)
end
