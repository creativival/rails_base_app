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

  trait :with_avatar do
    avatar { fixture_file_upload(Rails.root.join('spec', 'support', 'assets', 'avatar.png')) }
  end

  trait :with_too_large_avatar do
    avatar { fixture_file_upload(Rails.root.join('spec', 'support', 'assets', 'large_size.jpg')) }
  end

  trait :with_not_image do
    avatar { fixture_file_upload(Rails.root.join('spec', 'support', 'assets', 'test.txt')) }
  end
end