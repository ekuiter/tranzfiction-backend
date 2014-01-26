require "faker"

FactoryGirl.define do
  factory :city do
    name { Faker::Lorem.characters(10) }
    user
    
    factory :invalid_city do
      name nil
    end
  end
end