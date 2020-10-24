# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# LetterOpnerでメールが開かれないようにする
ActionMailer::Base.perform_deliveries = false

# Active Admin
User.create!(name: 'admin',
             email: 'admin@example.com',
             password: 'password',
             confirmed_at: Time.current,
             # role: 1, # admin
             )

# Facker
100.times do |n|
  name = Faker::Movies::StarWars.character
  email = "#{name.gsub(' ', '_').downcase}@example#{format("%03d", n + 1)}.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               confirmed_at: Time.current,
               # role: 0,
               )
  end
