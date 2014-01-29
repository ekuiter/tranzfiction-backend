class WorkerController < ApplicationController
  skip_before_filter :authenticate_user!
  around_filter :authenticate_worker

  def gain
    City.includes([:buildings, :resources]).each do |city|
      resources = city.resources
      city.buildings.each do |building|
        resources = building.gain resources if building.respond_to? :gain
      end
      resources.save
    end
    render json: "Ressourcen abgebaut"
  end
  
  private
  
  def authenticate_worker
    if params[:password] == Defaults::Worker::password
      yield
    else
      render json: "Keine Berechtigung", status: 401
    end
  end
end
