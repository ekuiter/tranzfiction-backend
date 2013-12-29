class MetaController < ApplicationController  
  def home
    @cities = current_user.cities
  end
end
