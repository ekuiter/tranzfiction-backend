require "spec_helper"

describe BuildingController do  
  let(:city) { building.city }
  let(:buildings) { building.city.buildings }
  let(:building_attributes) { attributes_for(:building) }
  let(:invalid_building_attributes) { attributes_for(:invalid_building) }
  
  let :building do
    building = create(:building, city: create(:city, user: user))
    building.becomes(building.type.constantize)
  end
  
  let :lvl2_building do
    building = create(:building, city: create(:city, user: user), level: 2)
    building.becomes(building.type.constantize)
  end
  
  [:user, :admin].each do |role|
    context logged_in(role) do
      let!(:user) { login(role) }  
      
      [:show, :destroy, :index, :upgrade].each do |action|
        describe action do
          context "without city and building" do
            before { get action }
            it("renders 404") { expect(response.status).to eq 404 }
          end
        end
      end
     
      [:show, :destroy].each do |action|
        describe action do
          context "with city and building" do
            before { get action, city_id: city.id, building_id: building.id }
            it("assigns @city") { expect(assigns(:city)).to eq city }
            it("assigns @building") { expect(assigns(:building)).to eq building }
            it("renders @building as JSON") { expect(response.body).to be_json(building) }
          end
        end
      end
      
      describe :index do
        context "with city" do
          before { get :index, city_id: city.id }
          it("assigns @city") { expect(assigns(:city)).to eq city }
          it("assigns @buildings") { expect(assigns(:buildings)).to eq buildings }
          it("renders JSON") { expect(response.body).to be_json(buildings) }
        end
      end
 
      describe :create do
        context "with city" do
          context "with valid attributes" do
            before { get :create, city_id: city.id, building: building_attributes }
            it("saves @building") { expect(assigns(:building)).not_to be_new_record }
            it("renders @building as JSON") { expect(response.body).to be_json }
          end
    
          context "with invalid attributes" do
            before { get :create, city_id: city.id, building: invalid_building_attributes }
            it("does not save a new @building") { expect(assigns(:building)).to be_new_record }
            it("renders 400") { expect(response.status).to eq 400 }
            it("renders errors as JSON") { expect(response.body).to be_json }
          end
        end
        
        context "without city" do
          before { get :create, building: building_attributes }
          it("renders 404") { expect(response.status).to eq 404 }
        end
      end

      describe :destroy do    
        context "with city and building" do
          it "destroys @building" do
            building
            expect { get :destroy, city_id: city.id, building_id: building.id }.to change { city.buildings.count }.by(-1)
          end
        end
      end
      
      describe :upgrade do      
        context "with city and building" do
          before { get :upgrade, city_id: city.id, building_id: building.id }
          it("assigns @city") { expect(assigns(:city)).to eq city }
          it("assigns @building") { expect(assigns(:building)).to eq building }
          it("upgrades @building") { expect(building.reload.level).to eq 2 }
          it("renders @building as JSON") { expect(response.body).to be_json(building.reload) }
        end
      end
    end
  end
  
  context logged_in(:user) do
    let!(:user) { login(:user) }
    
    describe :downgrade do
      before { get :downgrade, city_id: city.id, building_id: building.id }
      it("renders 401") { expect(response.status).to eq 401 }
    end
  end

  context logged_in(:admin) do
    let!(:user) { login(:admin) }
    
    describe :downgrade do    
      context "with city and building" do
        before { get :downgrade, city_id: lvl2_building.city.id, building_id: lvl2_building.id }
        it("assigns @city") { expect(assigns(:city)).to eq lvl2_building.city }
        it("assigns @building") { expect(assigns(:building)).to eq lvl2_building }

        context "level 2" do
          it("downgrades @building") { expect(lvl2_building.reload.level).to eq 1 }
          it("renders @building as JSON") { expect(response.body).to be_json(lvl2_building.reload) }
        end
          
        context "level 1" do
          it("does not downgrade @building") { expect(building.reload.level).to eq 1 }
          it("renders errors as JSON") { expect(response.body).to be_json }
        end
      end
             
      context "without city and building" do
        before { get :downgrade }
        it("renders 404") { expect(response.status).to eq 404 }
      end
    end
  end

  context not_logged_in do
    [:index, :show, :destroy, :create, :upgrade, :downgrade].each do |action|
      describe action do
        before { get action }
        it("renders 302") { expect(response.status).to eq 302 }
      end
    end
  end

end
