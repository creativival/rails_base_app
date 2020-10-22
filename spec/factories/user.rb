FactoryBot.define do
  factory :user, class: User do
    name { 'user' }
    email { "user@example.com" }
    password { 'password' }
    confirmed_at { Time.current }
  end

  (1..11).each do |i|
    user = "user#{ i }"
    factory user.to_sym, class: User do
      name { user }
      email { "#{ user }@example.com" }
      password { 'password' }
      confirmed_at { Time.current }
    end
  end
end