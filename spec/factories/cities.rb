require 'faker'

FactoryGirl.define do
  factory :city do
    name { Faker::Lorem.characters(10) }
    user
  end
end