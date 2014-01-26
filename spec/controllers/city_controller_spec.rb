require "spec_helper"

# Controller-Specs enthalten Folgendes:
# @Zuweisungen
# (Response Code (200, 404) - hier unwichtig, da die API immer 200 zurückgibt)
# Parameter - falls Parameter übergeben werden, müssen diese in good und bad case unterschieden werden
# Datenbank - alle Speicher-/nicht Speichervorgänge müssen betrachtet werden

describe CityController do  
  let(:city) { create(:city, user: user) }
  let(:cities) { user.cities }
  let(:city_attributes) { attributes_for(:city) }
  let(:invalid_city_attributes) { attributes_for(:invalid_city) }
  
  [:user, :admin].each do |role|
    context logged_in(role) do
      let!(:user) { login(role) }  
      
      [:show, :destroy].each do |action|
        describe action do
          context "with resource" do
            before { get action, id: city.id }
            it("assigns @city") { expect(assigns(:city)).to eq city }
            it("renders @city as JSON") { expect(response.body).to be_json(city) }
          end
      
          context "without resource" do
            before { get action }
            it("renders 404") { expect(response.status).to eq 404 }
          end
        end
      end
      
      describe :index do
        before { get :index }
        it("assigns @cities") { expect(assigns(:cities)).to eq cities }
        it("renders JSON") { expect(response.body).to be_json(cities) }
      end
  
      describe :create do  
        context "with valid attributes" do
          before { get :create, city: city_attributes }
          it("saves @city") { expect(assigns(:city)).not_to be_new_record }
          it("renders @city as JSON") { expect(response.body).to be_json }
        end
    
        context "with invalid attributes" do
          before { get :create, city: invalid_city_attributes }
          it("does not save a new @city") { expect(assigns(:city)).to be_new_record }
          it("renders 400") { expect(response.status).to eq 400 }
          it("renders errors as JSON") { expect(response.body).to be_json }
        end
      end
  
      describe :destroy do    
        context "with resource" do
          it "destroys @city" do
            city
            expect { get :destroy, id: city.id }.to change { user.cities.count }.by(-1)
          end
        end
      end
    end
  end
  
  context logged_in(:admin) do
    let!(:user) { login(:admin) }
    
    describe :reset do      
      context "with resource" do
        before { get :reset, id: city.id }
        let(:city) { create(:city, user: user, buildings: [create(:building)]) }
        
        it("assigns @city") { expect(assigns(:city)).to eq city }
        it("resets @city") { expect(city.buildings.count).to eq 0 }
        it("renders @city as JSON") { expect(response.body).to be_json(city) }
      end
      
      context "without resource" do
        before { get :reset }
        it("renders 404") { expect(response.status).to eq 404 }
      end
    end
  end
  
  context not_logged_in do
    [:index, :show, :destroy, :reset, :create].each do |action|
      describe action do
        before { get action }
        it("renders 302") { expect(response.status).to eq 302 }
      end
    end
  end
end
