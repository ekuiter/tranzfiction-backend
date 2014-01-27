require "spec_helper"

describe MetaController do  
  let(:cities) { user.cities }
  
  login [:user, :admin] do
    describe :home do
      get!.assigns(:cities).renders(template: :home)
    end
    
    describe :api do
      get!.assigns(:types) { Building.valid_types_tree }.renders(template: :api)
    end
    
    describe :user do
      get!.assigns(:user).renders(json: :user)
    end
  end
  
  no_login do
    describe :user do
      get!.assigns(:user) { nil }.renders "null"
    end
  end
end