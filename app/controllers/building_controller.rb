class BuildingController < ApplicationController
  
  before_filter :set_city, only: [:index, :create]
  before_filter :set_building, only: [:show, :destroy]
  
  def index
    render json: @city.buildings
  end
  
  def create
    @building = @city.buildings.new(building_params.merge(level: 1) )
    if @building.save
      render json: @building
    else
      render json: @building.errors, status: :unprocessable_entity
    end
  end
  
  def show
    render json: @building
  end
  
  def destroy
    @building.destroy
    render json: "Gebäude gelöscht"
  end
  
  private
  
  def building_params
    return params[:building].permit(:type) if params[:building]
    {}
  end
  
  def set_city
    @city = current_user.cities.find(params[:city_id])
  end
  
  def set_building
    @building = set_city.buildings.find(params[:building_id])
  end
  
end
