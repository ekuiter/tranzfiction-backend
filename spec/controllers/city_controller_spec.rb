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
  
  login [:user, :admin] do
    describe_actions [:show, :destroy] do |action|
      context "with parameters" do
        get!(action) { { id: city.id } }.assigns(:city).renders(json: :city)
      end
  
      status_without_params! 404
    end
    
    describe :index do
      get!.assigns(:cities).renders(json: :cities)
    end

    describe :create do  
      context "with valid attributes" do
        before { get :create, city: city_attributes }
        it("saves @city") { expect(assigns(:city)).not_to be_new_record }
        renders :json
      end
  
      context "with invalid attributes" do
        before { get :create, city: invalid_city_attributes }
        it("does not save a new @city") { expect(assigns(:city)).to be_new_record }
        status(400).renders(:json)
      end
    end

    describe :destroy do    
      context "with parameters" do
        destroys { { id: city.id, collection: user.cities } }
      end
    end
  end
  
  login :admin do
    describe :reset do      
      context "with parameters" do
        before { get :reset, id: city.id }
        let(:city) { create(:city, user: user, buildings: [create(:building)]) }
        it("resets @city") { expect(city.buildings.count).to eq 0 }
        assigns(:city).renders(json: :city)
      end
      
      status_without_params! 404
    end
  end
  
  no_login do
    describe_actions [:index, :show, :destroy, :reset, :create] do |action|
      status_without_params! 302
    end
  end
end
