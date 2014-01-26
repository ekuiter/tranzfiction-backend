require "spec_helper"

describe MetaController do  
  let(:cities) { user.cities }
  
  [:user, :admin].each do |role|
    context logged_in(role) do
      let!(:user) { login(role) }
          
      describe :home do
        before { get :home }
        it("assigns @cities") { expect(assigns(:cities)).to eq cities }
        it("renders") { expect(response).to render_template :home }
      end
      
      describe :api do
        before { get :api }
        it("assigns @types") { expect(assigns(:types)).to eq Building.valid_types_tree }
        it("renders") { expect(response).to render_template :api }
      end
      
      describe :user do
        before { get :user }
        it("assigns @user") { expect(assigns(:user)).to eq user }
        it("renders @user as JSON") { expect(response.body).to be_json(user) }
      end
    end
  end
  
  context not_logged_in do
    describe :user do
      before { get :user }
      it("assigns nothing to @user") { expect(assigns(:user)).to be_blank }
      it("renders null") { expect(response.body).to eq "null" }
    end
  end
end