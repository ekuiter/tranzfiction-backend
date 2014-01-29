require "spec_helper"

describe WorkerController do  
  context "logged in" do
    describe :gain do
      before { create(:resource_building) }
      get! { { password: Defaults::Worker::password } }.status(200)
    end
  end
  
  context "not logged in" do
    describe :gain do
      get!.status(401)
    end
  end
end
