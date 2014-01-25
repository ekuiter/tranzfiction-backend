require 'faker'

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Lorem.characters(14) }
    
    factory :admin do
      admin true
    end
  end
end