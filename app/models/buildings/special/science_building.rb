class ScienceBuilding < SpecialBuilding
  def upgrade_resources
    Resources.by_formula level: level, efactor: 0.25, silicon: 40, plastic: 30, graphite: 50
  end
  
  def time_factor
    440
  end
end