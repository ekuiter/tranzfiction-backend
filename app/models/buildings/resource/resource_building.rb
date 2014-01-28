class ResourceBuilding < Building
  def gain(resources=nil)
    resources ||= city.resources
    resources.gain resource, calculate_gain
  end
  
  private
  
  def gain_per_hour
    100
  end
  
  def calculate_gain
    gain_per_hour / (3600.0 / Defaults::Building::gain_interval)
  end
end