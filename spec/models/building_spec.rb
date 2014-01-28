require "spec_helper"

describe Building do
  let(:building) { create(:building) }
  let(:lvl2_building) { create(:building, level: 2) }
  it("has a valid factory") { expect(building).to be_valid }
  it("is invalid without a city") { expect(build(:building, city: nil)).not_to be_valid }
  it("is invalid without a level") { expect(build(:building, level: nil)).not_to be_valid }
  it("is invalid without a numeric level") { expect(build(:building, level: "test")).not_to be_valid }
  it("is invalid with a too small level") { expect(build(:building, level: 0)).not_to be_valid }
  it("is invalid without a type") { expect(build(:building, type: nil)).not_to be_valid }
  it("is invalid with an invalid type") { expect(build(:building, type: Faker::Lorem.words)).not_to be_valid }
  it("has a title") { expect(building.title).not_to be_blank }
  it("has a description") { expect(building.description).not_to be_blank }
  it("has a image") { expect(building.image).not_to be_blank }
  it("has a energy consumption") { expect(building.energy_consumption).not_to be_blank }
  it("has upgrade resources") { expect(building.upgrade_resources).not_to be_blank }
  
  describe "actions" do
    it("upgrades") { expect(building.upgrade).to eq building }
    
    context "level 1" do
      it("does not downgrade") { expect(building.downgrade).not_to eq building }
    end
    
    context "level 2" do
      it("downgrades") { expect(lvl2_building.downgrade).to eq lvl2_building }
    end
  end
  
  describe "valid types" do
    it("returns all") { validate_types Building.valid_types }
    
    it "returns all as a tree" do
      Building.valid_types_tree.each do |supertype, types|
        expect([:EnergyBuilding, :ResourceBuilding, :SpecialBuilding]).to include(supertype)
        validate_types types
      end
    end
  
    def validate_types(types)
      types.each do |type|
        expect(build(:building, type: type)).to be_valid
      end
    end
  end
end