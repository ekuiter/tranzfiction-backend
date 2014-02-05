require "faker"

FactoryGirl.define do
  factory :resources do
    silicon 1000
    plastic 1000
    graphite 1000
    
    factory :many_resources do
      silicon 10000
      plastic 10000
      graphite 10000
    end
    
    factory :few_resources do
      silicon 100
      plastic 100
      graphite 100
    end
    
    factory :random_resources do
      silicon { 50.0 * rand + 100 }
      plastic { 50.0 * rand + 100 }
      graphite { 50.0 * rand + 100 }
    end
  end
end