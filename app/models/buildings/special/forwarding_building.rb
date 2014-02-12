class ForwardingBuilding < SpecialBuilding
  def upgrade_resources
    Resources.by_formula level: level, efactor: 0.25, silicon: 50, plastic: 40, graphite: 30
  end
  
  def time_factor
    450
  end
end