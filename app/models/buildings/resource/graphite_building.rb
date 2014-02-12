class GraphiteBuilding < ResourceBuilding
  def resource
    :graphite
  end
  
  def upgrade_resources
    Resources.by_formula level: level, efactor: 0.5, silicon: 60, plastic: 48, graphite: 18
  end
  
  def time_factor
    500
  end
end