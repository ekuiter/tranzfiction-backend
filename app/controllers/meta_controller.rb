class MetaController < ApplicationController  
  skip_before_filter :authenticate_user!, only: [:user]
  skip_before_filter :custom_authenticate_user!, only: [:user]
  
  def home
    if cookies[:frontend_login] == "true"
      redirect_to "http://tranzfiction.com"
    else
      @cities = current_user.cities.includes([:buildings, :resources])
    end
  end
  
  def api
    @types = Building.valid_types_tree
  end
  
  def user
    begin
      user = User.where(email: params[:email]).first
      if user.valid_password?(params[:password])
        sign_in user, store: false
      else
        raise
      end
    rescue
    end
    @user = current_user
    render json: @user
  end
end
