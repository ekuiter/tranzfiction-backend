require "spec_helper"

describe ResourceBuilding do
  let(:building) { create(:resource_building).cast }
  let(:resource) { building.resource }
  it("has a valid factory") { expect(building).to be_valid }
  it("gains resources") { expect { building.gain }.to change { building.city.resources.send(resource) } }
end