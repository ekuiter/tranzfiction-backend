require "spec_helper"

describe Resources do
  let(:resources) { create(:resources) }
  let(:amount) { 1000.0 * rand }
  it("has a valid factory") { expect(resources).to be_valid }
  it("is invalid without silicon") { expect(build(:resources, silicon: nil)).not_to be_valid }
  it("is invalid without plastic") { expect(build(:resources, plastic: nil)).not_to be_valid }
  it("is invalid without graphite") { expect(build(:resources, graphite: nil)).not_to be_valid }
  it("is invalid with too few silicon") { expect(build(:resources, silicon: -1)).not_to be_valid }
  it("is invalid with too few plastic") { expect(build(:resources, plastic: -1)).not_to be_valid }
  it("is invalid with too few graphite") { expect(build(:resources, graphite: -1)).not_to be_valid }
  it("is invalid with too much silicon") { expect(build(:resources, silicon: 1000000)).not_to be_valid }
  it("is invalid with too much plastic") { expect(build(:resources, plastic: 1000000)).not_to be_valid }
  it("is invalid with too much graphite") { expect(build(:resources, graphite: 1000000)).not_to be_valid }
  
  def gains(resource)
    expect { resources.gain(resource.to_sym, amount) }.to change { resources.send(resource.to_sym) }.by(amount)
  end
  
  it("gains silicon") { gains :silicon }
  it("gains plastic") { gains :plastic }
  it("gains graphite") { gains :graphite }
end