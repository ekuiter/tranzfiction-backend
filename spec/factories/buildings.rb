require "faker"

FactoryGirl.define do
  factory :building do
    level 1
    type { Building.valid_types.sample }
    city
    
    factory :invalid_building do
      type { Faker::Lorem.words }
    end
  end
end