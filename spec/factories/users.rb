require "faker"

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Lorem.characters(14) }
    confirmed_at { Time.now }
    planet { Faker::Lorem.characters(10) }
    
    factory :admin do
      admin true
    end
  end
end