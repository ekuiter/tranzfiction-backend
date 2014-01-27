require "spec_helper"

describe User do
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }
  it("has a valid factory") { expect(user).to be_valid }
  it("has a valid admin factory") { expect(admin).to be_valid }
  it("is invalid without an email") { expect(build(:user, email: nil)).not_to be_valid }
  it("is invalid without a well-formatted email") { expect(build(:user, email: Faker::Lorem.words)).not_to be_valid }
  it("is invalid without a password") { expect(build(:user, password: nil)).not_to be_valid }
  it("is invalid with a too short password") { expect(build(:user, password: Faker::Lorem.characters(7))).not_to be_valid }
  it("is invalid with a too long password") { expect(build(:user, password: Faker::Lorem.characters(129))).not_to be_valid }
  it("has a numeric city limit") { expect(user.city_limit).to be_kind_of Numeric }
  it("is invalid without a planet") { expect(build(:user, planet: nil)).not_to be_valid }
  it("is invalid with a too short planet") { expect(build(:user, planet: Faker::Lorem.characters(2))).not_to be_valid }
  it("is invalid with a too long planet") { expect(build(:user, planet: Faker::Lorem.characters(51))) }
  
  it "is invalid with an already taken email" do
    email = Faker::Internet.email
    create(:user, email: email)
    expect(build(:user, email: email)).not_to be_valid
  end
  
  describe "admin" do    
    context "when last" do
      it("is not removed") { expect(admin.destroy).to eq false }
      it "is not updated" do
        admin.admin = false
        expect(admin).not_to be_valid
      end
      it("knows it's the last admin") { expect(admin.last_admin?).to eq true }
    end
    
    context "when not last" do
      before { create(:admin) }
      it("is removed") { expect(admin.destroy).not_to eq false }
      it("knows it's not the last admin") { expect(admin.last_admin?).to eq false }
      it "is updated" do
        admin.admin = false
        expect(admin).to be_valid
      end
    end
    
    it "counts admins" do
      expect(User.admin_count).to eq 0
      5.times { create(:admin) }
      expect(User.admin_count).to eq 5
      2.times { User.last.destroy }
      expect(User.admin_count).to eq 3
      User.all[0..1].map { |admin| admin.update_attributes(admin: false) }
      expect(User.admin_count).to eq 1
    end
  end
end