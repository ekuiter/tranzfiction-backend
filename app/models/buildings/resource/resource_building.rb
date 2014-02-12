class ResourceBuilding < Building
  def gain(resources=nil, since_last_gain=nil)
    resources ||= city.resources
    resources.gain(resource, calculate_gain(since_last_gain))
  end
  
  def calculate_gain(since_last_gain)
    since_last_gain ||= Configuration.since_last_gain
    gain_per_hour / (3600.0 / since_last_gain)
  end
  
  # alle ResourceBuildings produzieren abhängig von ihrem Level dieselbe Anzahl Rohstoffe.
  # die dafür nötige Formel wurde per Regression ermittelt (siehe silicon_building.rb)
  def gain_per_hour
    Building.solve_formula level: level, factor: 23, efactor: 0.25
  end
end