require "spec_helper"

describe Resources do
  let(:resources) { create(:resources) }
  let(:random_resources) { create(:resources) }
  let(:amount) { 1000.0 * rand }
  it("has a valid factory") { expect(resources).to be_valid }
  it("is empty") { expect(Resources.create).to eq Resources.empty }
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
  
  describe "operations" do
    let(:res1) { random_resources }
    let(:res2) { random_resources }
    let(:many_resources) { create(:many_resources) }
    let(:few_resources) { create(:few_resources) }
    
    it "adds" do
      new_resources = res1 + res2
      expect(new_resources.silicon).to eq res1.silicon + res2.silicon
      expect(new_resources.plastic).to eq res1.plastic + res2.plastic
      expect(new_resources.graphite).to eq res1.graphite + res2.graphite
    end
  
    it "subtracts" do
      new_resources = res1 - res2
      expect(new_resources.silicon).to eq res1.silicon - res2.silicon
      expect(new_resources.plastic).to eq res1.plastic - res2.plastic
      expect(new_resources.graphite).to eq res1.graphite - res2.graphite
    end
    
    it "subtracts to zero" do
      new_resources = few_resources.subtract_to_zero many_resources
      expect(new_resources.silicon).to eq 0
      expect(new_resources.plastic).to eq 0
      expect(new_resources.graphite).to eq 0
    end
    
    it "compares" do
      expect(random_resources).to eq random_resources
      expect(many_resources).not_to eq few_resources
      expect(random_resources).to be >= random_resources
      expect(random_resources).to be <= random_resources
      expect(many_resources).to be > few_resources
      expect(few_resources).to be < many_resources
      expect(many_resources).not_to be < few_resources
      expect(few_resources).not_to be > many_resources
    end
  end
  
  it "empties" do
    random_resources.empty!
    expect(random_resources).to eq Resources.empty
  end
end