class CityController < ApplicationController
  
  before_filter :set_city, only: [:show, :destroy, :reset]
  before_filter :admin, only: [:reset]
  
  def index
    render json: current_user.cities
  end
  
  def create
    @city = current_user.cities.new(city_params)
    if @city.save
      render json: @city
    else
      render json: @city.errors
    end
  end
  
  def show
    render json: @city
  end
  
  def destroy
    @city.destroy
    render json: "Stadt gelöscht"
  end
  
  def reset
    render json: @city.reset
  end
  
  private
  
  def city_params
    params[:city].permit(:name) if params[:city]
  end
  
  def set_city
    @city = current_user.cities.find(params[:id])
  end
  
end
