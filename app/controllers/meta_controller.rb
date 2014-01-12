class MetaController < ApplicationController  
  skip_before_filter :authenticate_user!, only: [:user]
  
  def home
    @cities = current_user.cities
  end
  
  def api
  end
  
  def user
    render json: current_user
  end
end
