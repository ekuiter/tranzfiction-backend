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
    @user = current_user
    render json: @user
  end
end
