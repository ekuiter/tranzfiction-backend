require 'spec_helper'

describe City do
  it "has a valid factory" do
    create(:city).should be_valid
  end
  
  it "is invalid without a user" do
    build(:city, user: nil).should_not be_valid
  end
  
  it "is invalid without a name" do
    build(:city, name: nil).should_not be_valid
  end
  
  it "is invalid with a too short name" do
    build(:city, name: Faker::Lorem.characters(2)).should_not be_valid
  end
  
  it "is invalid with a too long name" do
    build(:city, name: Faker::Lorem.characters(100)).should_not be_valid
  end
  
  it "is invalid with an already taken name" do
    user = create(:user)
    create(:city, user: user, name: "Teststadt")
    build(:city, user: user, name: "Teststadt").should_not be_valid
  end
  
  it "is invalid if it exceeds the city limit" do
    user = create(:user)
    user.city_limit.times { create(:city, user: user) }
    build(:city, user: user).should_not be_valid
  end
  
  it "resets by deleting all of its buildings" do
    city = create(:city)
    5.times { create(:building, city: city) }
    city.reset
    city.buildings.should be_blank
  end

  it "has a build speed" do
    create(:city).build_speed.should be_kind_of(Numeric)
  end
end