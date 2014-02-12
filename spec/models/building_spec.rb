require "spec_helper"

describe Building do
  let(:building) { create(:building).cast }
  let(:built_building) do 
    b = create(:building)
    b.update_attributes ready_at: Time.now
    b.cast
  end
  let(:lvl2_building) { create(:building, level: 2) }
  it("has a valid factory") { expect(building).to be_valid }
  it("is invalid without a city") { expect(build(:building, city: nil)).not_to be_valid }
  it("is invalid without a level") { expect(build(:building, level: nil)).not_to be_valid }
  it("is invalid without a numeric level") { expect(build(:building, level: "test")).not_to be_valid }
  it("is invalid with a too small level") { expect(build(:building, level: 0)).not_to be_valid }
  it("is invalid without a type") { expect(build(:building, type: nil)).not_to be_valid }
  it("is invalid with an invalid type") { expect(build(:building, type: Faker::Lorem.words)).not_to be_valid }
  it("has a energy consumption") { expect(building.energy_consumption).not_to be_blank }
  it("has upgrade resources") { expect(building.upgrade_resources).not_to be_blank }
  
  describe "build" do
    let(:city) { create(:city) }
    let(:success) { Building.build(city, attributes_for(:building_type).merge(level: 1)).last }
    
    context "with resources" do
      it "builds" do
        expect(success).to be_true
      end
    end
    
    context "without resources" do
      it "does not build" do
        city.resources.empty!
        expect(success).to be_false
      end
    end
  end
  
  describe "actions" do
    describe "upgrade" do  
      context "with resources" do
        it "upgrades" do
          built_building.city.resources = create(:resources)
          old_resources = built_building.city.resources
          new_resources = old_resources - built_building.upgrade_resources
          level = built_building.level
          built_building.upgrade!
          expect(built_building.level).to eq level + 1
          expect(built_building.city.resources).to eq new_resources
        end
      end
      
      context "without resources" do
        it "does not upgrade" do
          built_building.city.resources.empty!
          expect { built_building.upgrade! }.not_to change { built_building.level }.by(1)
          expect(built_building.errors.messages[:missing_resources].first).to(
            eq(built_building.upgrade_resources.subtract_to_zero(built_building.city.resources))
          )
        end
      end
    end
      
    describe "downgrade" do
      context "level 1" do
        it("does not downgrade") { expect(building.downgrade!).not_to eq building }
      end
    
      context "level 2" do
        it("downgrades") { expect(lvl2_building.downgrade!).to eq lvl2_building }
      end
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
  
  describe "ready" do
    context "new building" do
      it("is not ready") { expect(building.ready?).to be_false }
      it("is ready_in") { expect(building.ready_in).to be_within(1).of(building.upgrade_time) }
    end
    
    context "built building" do
      before { building.ready_at = Time.now }
      it("is ready") { expect(building.ready?).to be_true }
      it("is not ready_in") { expect(building.ready_in).to eq 0 }
    end
  end
end