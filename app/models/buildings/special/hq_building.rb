class HqBuilding < SpecialBuilding
  def upgrade_resources
    Resources.by_formula level: level, efactor: 0.25, silicon: 55, plastic: 30, graphite: 45
  end
  
  def time_factor
    420
  end
  
  # wenn ein HqBuilding errichtet wurde, erhöht es die Baugeschwindigkeit
  # der Stadt durch jedes neue Level um 10%.
  def affect_build_speed(hash={})
    hash[:level] ||= level
    1 + hash[:level] * 0.05
  end
end