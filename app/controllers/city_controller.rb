class CityController < ApplicationController
  
  before_filter :set_city, only: [:show, :destroy, :reset]
  before_filter :admin, only: [:reset]
  
  def index
    @cities = current_user.cities
    render json: @cities.includes(:resources)
  end
  
  def create
    @city = current_user.cities.new(city_params)
    if @city.save
      render json: @city
    else
      render json: @city.errors, status: 400
    end
  end
  
  def show
    render json: @city
  end
  
  def destroy
    @city.destroy
    render json: @city
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
