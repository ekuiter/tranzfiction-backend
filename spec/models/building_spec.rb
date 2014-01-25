require 'spec_helper'

describe Building do
  it "has a valid factory" do
    create(:building).should be_valid
  end
  
  it "is invalid without a city" do
    build(:building, city: nil).should_not be_valid
  end
  
  it "is invalid without a level" do
    build(:building, level: nil).should_not be_valid
  end
  
  it "is invalid without a numeric level" do
    build(:building, level: "test").should_not be_valid
  end
  
  it "is invalid with a too small level" do
    build(:building, level: 0).should_not be_valid
  end
  
  it "is invalid without a type" do
    build(:building, type: nil).should_not be_valid
  end
  
  it "is invalid with an invalid type" do
    build(:building, type: Faker::Lorem.words).should_not be_valid
  end
  
  it "has a title, description, image, energy consumption and upgrade resources" do
    building = create(:building)
    building.title.should_not be_blank
    building.description.should_not be_blank
    building.image.should_not be_blank
    building.energy_consumption.should_not be_blank
    building.upgrade_resources.should_not be_blank
  end
  
  describe "actions" do
    before :each do
      @building = create(:building)
    end
    
    it "can be processed" do
      @building.process.should == true
    end
  
    it "upgrades" do
      @building.upgrade.should == @building
    end
    
    context "level 1" do
      it "does not downgrade" do
        @building.downgrade.should_not == @building
      end
    end
    
    context "level 2" do
      before :each do
        @building = create(:building, level: 2)
      end
            
      it "downgrades" do
        @building.downgrade.should == @building
      end
    end
  end
  
  it "returns all valid building types" do
    Building.valid_types.each do |type|
      build(:building, type: type).should be_valid
    end
  end
  
end