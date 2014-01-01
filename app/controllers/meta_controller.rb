class MetaController < ApplicationController  
  def home
    @cities = current_user.cities
  end
  
  def api
  end
end
