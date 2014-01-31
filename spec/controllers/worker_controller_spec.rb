require "spec_helper"

describe WorkerController do  
  context "logged in" do
    describe :gain do
      before { create(:resource_building) }
      get! { { password: Defaults::Worker::password } }.status(200).renders(:json) { { since_last_gain: assigns(:since_last_gain), gained_resources: assigns(:gained_resources) } }
      it("assigns @gained_resources") do
        expect(assigns(:gained_resources)).to be_kind_of Array
        expect(assigns(:gained_resources).count).to eq City.count
      end
    end
  end
  
  context "not logged in" do
    describe :gain do
      get!.status(401)
    end
  end
end
