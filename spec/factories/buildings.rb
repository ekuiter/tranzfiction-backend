require "faker"

FactoryGirl.define do
  factory :building do
    level 1
    type { Building.valid_types.sample }
    city
    
    factory :invalid_building do
      type { Faker::Lorem.words }
    end
    
    factory :resource_building do
      type { Building.valid_types_tree[:ResourceBuilding].sample }
    end
  end
  
  factory :building_type, class: Building do
    type { Building.valid_types.sample }
  end
end