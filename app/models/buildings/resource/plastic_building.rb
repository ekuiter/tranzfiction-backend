class PlasticBuilding < ResourceBuilding  
  def resource
    :plastic
  end
  
  def upgrade_resources
    Resources.by_formula level: level, efactor: 0.5, silicon: 48, plastic: 24, graphite: 48
  end
  
  def time_factor
    350
  end
end