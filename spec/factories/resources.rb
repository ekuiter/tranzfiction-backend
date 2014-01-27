require "faker"

FactoryGirl.define do
  factory :resources do
    silicon 1000
    plastic 1000
    graphite 1000
    city
  end
end