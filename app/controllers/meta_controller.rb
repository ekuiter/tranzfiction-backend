class MetaController < ApplicationController  
  skip_before_filter :authenticate_user!, only: [:user]
  
  def home
    @cities = current_user.cities.includes([:buildings, :resources])
  end
  
  def api
    @types = Building.valid_types_tree
  end
  
  def user
    @user = current_user
    render json: @user
  end
end
