class MetaController < ApplicationController  
  skip_before_filter :authenticate_user!, only: [:user]
  
  def home
    @cities = current_user.cities
  end
  
  def api
    types = Building.valid_types
    @types = { EnergyBuilding: [], ResourceBuilding: [], SpecialBuilding: [] }
    types.map do |type|
      @types[type.constantize.superclass.to_s.to_sym].push type
    end
  end
  
  def user
    render json: current_user
  end
end
