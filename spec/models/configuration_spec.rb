require "spec_helper"

describe Configuration do
  let(:configuration) { create(:configuration) }
  it("has a valid factory") { expect(configuration).to be_valid }
  it("is invalid without a key") { expect(build(:configuration, key: nil)).not_to be_valid } 
  it("is invalid without a value") { expect(build(:configuration, value: nil)).not_to be_valid }
  
  it "is invalid with an already taken key" do
    create(:configuration, key: "test")
    expect(build(:configuration, key: "test")).not_to be_valid
  end
  
  describe "last gain" do    
    context "gained" do
      let(:time) { Time.now }
      before { Configuration.last_gain = time }
      it("is is not blank") { expect(Configuration.last_gain).not_to be_blank }
      it("is correct") { expect(Configuration.last_gain).to be_the_same_time_as time }
    end
  end
  
  describe "since last gain" do
    context "not gained" do
      it("is about 1") { expect(Configuration.since_last_gain.round).to eq 1 }
    end
    
    context "gained" do
      before { Configuration.last_gain = Time.now }
      it("is is not blank") { expect(Configuration.since_last_gain).not_to be_blank }
    end
  end
end
