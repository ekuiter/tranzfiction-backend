class CityController < ApplicationController
  
  before_filter :set_city, only: [:show]
  
  def index
    render json: current_user.cities
  end
  
  def create
    @city = current_user.cities.new(city_params)
    if @city.save
      render json: @city
    else
      render json: @city.errors, status: :unprocessable_entity
    end
  end
  
  def show
    render json: @city
  end
  
  private
  
  def city_params
    params[:city].permit(:name) if params[:city]
  end
  
  def set_city
    @city = current_user.cities.find(params[:id])
  end
  
end
