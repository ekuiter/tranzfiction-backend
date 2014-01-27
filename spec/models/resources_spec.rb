require "spec_helper"

describe Resources do
  let(:resources) { create(:resources) }
  it("has a valid factory") { expect(resources).to be_valid }
  it("is invalid without silicon") { expect(build(:resources, silicon: nil)).not_to be_valid }
  it("is invalid without plastic") { expect(build(:resources, plastic: nil)).not_to be_valid }
  it("is invalid without graphite") { expect(build(:resources, graphite: nil)).not_to be_valid }
  it("is invalid with too few silicon") { expect(build(:resources, silicon: 0)).not_to be_valid }
  it("is invalid with too few plastic") { expect(build(:resources, plastic: 0)).not_to be_valid }
  it("is invalid with too few graphite") { expect(build(:resources, graphite: 0)).not_to be_valid }
end