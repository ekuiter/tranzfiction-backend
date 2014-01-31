class ResourceBuilding < Building
  def gain(resources=nil, since_last_gain=nil)
    resources ||= city.resources
    resources.gain(resource, calculate_gain(since_last_gain))
  end
  
  private
  
  def gain_per_hour
    100
  end
  
  def calculate_gain(since_last_gain)
    since_last_gain ||= Configuration.since_last_gain
    gain_per_hour / (3600.0 / since_last_gain)
  end
end