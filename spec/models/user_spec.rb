require 'spec_helper'

describe User do
  it "has a valid factory" do
    create(:user).should be_valid
  end
  
  it "has a valid admin factory" do
    create(:admin).should be_valid
  end
  
  it "is invalid without an email" do
    build(:user, email: nil).should_not be_valid
  end
  
  it "is invalid with an already taken email" do
    email = Faker::Internet.email
    create(:user, email: email)
    build(:user, email: email).should_not be_valid
  end
  
  it "is invalid without a well-formatted email" do
    build(:user, email: Faker::Lorem.words).should_not be_valid
  end
  
  it "is invalid without a password" do
    build(:user, password: nil).should_not be_valid
  end
  
  it "is invalid with a too short password" do
    build(:user, password: Faker::Lorem.characters(7)).should_not be_valid
  end
  
  it "is invalid with a too long password" do
    build(:user, password: Faker::Lorem.characters(200)).should_not be_valid
  end
  
  describe "admin" do
    def destroy_admin
      create(:admin).destroy
    end
    
    def update_admin
      admin = create(:admin)
      admin.admin = false
      admin
    end
    
    context "last" do
      it "is not removed" do
        destroy_admin.should == false
      end
  
      it "is not updated" do
        update_admin.should_not be_valid
      end
      
      it "knows it's the last admin" do
        create(:admin).last_admin?.should == true
      end
    end
    
    context "not last" do
      before :each do
        create(:admin)
      end
      
      it "is removed" do
        destroy_admin.should_not == false
      end
  
      it "is updated" do
        update_admin.should be_valid
      end
      
      it "knows it's not the last admin" do
        create(:admin).last_admin?.should == false
      end
    end
    
    it "counts admins" do
      User.admin_count.should == 0
      5.times { create(:admin) }
      User.admin_count.should == 5
      2.times { User.last.destroy }
      User.admin_count.should == 3
      User.all[0..1].map do |admin|
        admin.admin = false
        admin.save
      end
      User.admin_count.should == 1
    end
  end
  
  it "has a city limit" do
    create(:user).city_limit.should be_kind_of(Numeric)
  end
end