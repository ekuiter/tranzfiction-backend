require 'faker'

FactoryGirl.define do
  factory :building do
    level 1
    type { Building.valid_types.sample }
    city
  end
end