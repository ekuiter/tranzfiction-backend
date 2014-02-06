class WorkerController < ApplicationController
  skip_before_filter :authenticate_user!
  around_filter :authenticate_worker

  def gain
    @since_last_gain = ::Configuration.since_last_gain
    @gained_resources = []
    
    City.includes([:buildings, :resources]).each do |city|
      new_resources = city.resources
      old_resources = new_resources.dup
      city.ready_buildings.each do |building|
        if building.respond_to? :gain
          new_resources = building.gain(new_resources, @since_last_gain)
        end
      end
      new_resources.save
      @gained_resources.push({
        city: city.id,
        gained_resources: (new_resources - old_resources).as_json(nil, :float)
      })
    end
    
    ::Configuration.last_gain = Time.now
    render json: {since_last_gain: @since_last_gain, gained_resources: @gained_resources}
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
