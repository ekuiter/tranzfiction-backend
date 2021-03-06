require "spec_helper"

describe City do
  let(:user) { create(:user) }
  let(:city) { create(:city) }
  it("has a valid factory") { expect(city).to be_valid }
  it("is invalid without a user") { expect(build(:city, user: nil)).not_to be_valid }
  it("is invalid without a name") { expect(build(:city, name: nil)).not_to be_valid }
  it("is invalid with a too short name") { expect(build(:city, name: Faker::Lorem.characters(2))).not_to be_valid }
  it("is invalid with a too long name") { expect(build(:city, name: Faker::Lorem.characters(51))).not_to be_valid }
  it("has a numeric build speed") { expect(city.build_speed).to be_kind_of Numeric }
  it("has starter resources") { expect(city.resources).to be > Resources.new(silicon: 0, plastic: 0, graphite: 0) }
  
  it "is invalid with an already taken name" do
    create(:city, user: user, name: "Teststadt")
    expect(build(:city, user: user, name: "Teststadt")).not_to be_valid
  end
  
  it "is invalid if it exceeds the city limit" do
    user.city_limit.times { create(:city, user: user) }
    expect(build(:city, user: user)).not_to be_valid
  end
  
  describe "buildings" do
    before { 5.times { create(:building, city: city) } }
    
    it "resets by deleting all of its buildings" do
      city.reset
      expect(city.buildings).to be_blank
    end
  
    it "returns ready buildings" do
      city.ready_buildings.each do |building|
        expect(building.ready?).to be_true
      end
    end
  end
end