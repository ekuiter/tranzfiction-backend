require "spec_helper"

describe BuildingController do
  let(:building) { create(:building, city: create(:city, user: user)).cast }
  let(:built_building) do 
    b = create(:building, city: create(:city, user: user)).cast
    b.update_attributes ready_at: Time.now
    b
  end
  let(:lvl2_building) { create(:building, city: create(:city, user: user), level: 2).cast }
  let(:city) { building.city }
  let(:buildings) { city.buildings }
  let(:building_attributes) { attributes_for(:building) }
  let(:invalid_building_attributes) { attributes_for(:invalid_building) }
  
  login :user, :admin do  
    describe_actions :show, :destroy, :index, :upgrade do |action|
      status_without_params! 404
    end
   
    describe_actions :show, :destroy do |action|
      context "with city and building" do
        get!(action) { { city_id: city.id, building_id: building.id } }.assigns(:city, :building).renders(json: :building)
      end
    end
    
    describe :index do
      context "with city" do
        get!(:index) { { city_id: city.id } }.assigns(:city, :buildings).renders(json: :buildings)
      end
    end

    describe :create do
      context "with city" do
        context "with valid attributes" do
          context "with resources" do
            before do
              city.resources = create(:resources)
              get :create, city_id: city.id, building: building_attributes
            end
            it("saves @building") { expect(assigns(:building)).not_to be_new_record }
            renders(:json)
          end
          
          context "without resources" do
            before do
              city.resources.empty!
              get :create, city_id: city.id, building: building_attributes
            end
            it("does not save @building") { expect(assigns(:building)).to be_new_record }
            renders(:json)
          end
        end
  
        context "with invalid attributes" do
          get!(:create) { { city_id: city.id, building: invalid_building_attributes } }.renders(:json).status(400)
          it("does not save a new @building") { expect(assigns(:building)).to be_new_record }
        end
      end
      
      status_with_params!(404, "without city") { { building: building_attributes } }
    end

    describe :destroy do    
      context "with city and building" do
        destroys { { city_id: city.id, building_id: building.id, collection: city.buildings } }
      end
    end
 
    describe :upgrade do      
      context "with city and building" do
        context "with resources" do
          before do
            built_building.city.resources = create(:resources)
            get :upgrade, city_id: built_building.city.id, building_id: built_building.id
          end
          assigns(:city) { built_building.city }.assigns(:building) { built_building }.renders(:json) { built_building.reload }
          it("upgrades @building") { expect(built_building.reload.level).to eq 2 }
        end
        
        context "without resources" do
          before do
            city.resources.empty!
            get :upgrade, city_id: city.id, building_id: building.id
          end
          assigns(:city, :building).renders(:json)
          it("upgrades @building") { expect(building.reload.level).to eq 1 }
        end
      end
    end
  end
  
  login :user do
    describe :downgrade do
      status_with_params!(401) { { city_id: city.id, building_id: building.id } }
    end
  end
  
  login :admin do
    describe :downgrade do    
      context "with city and building" do
        get!(:downgrade) { { city_id: lvl2_building.city.id, building_id: lvl2_building.id } }
        assigns(:city) { lvl2_building.city }.assigns(:building) { lvl2_building }
        
        context "level 2" do
          it("downgrades @building") { expect(lvl2_building.reload.level).to eq 1 }
          renders(:json) { lvl2_building.reload }
        end
          
        context "level 1" do
          it("does not downgrade @building") { expect(building.reload.level).to eq 1 }
          renders :json
        end
      end
             
      status_without_params! 404
    end
  end
  
  no_login do
    describe_actions :index, :show, :destroy, :create, :upgrade, :downgrade do |action|
      status_without_params! 302
    end
  end

end
