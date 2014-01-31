require "faker"

FactoryGirl.define do
  factory :configuration do
    key { Faker::Lorem.characters(10) }
    value { Faker::Lorem.characters(10) }
  end
end
