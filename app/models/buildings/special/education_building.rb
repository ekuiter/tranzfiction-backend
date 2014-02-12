class EducationBuilding < SpecialBuilding
  def upgrade_resources
    Resources.by_formula level: level, efactor: 0.25, silicon: 50, plastic: 35, graphite: 45
  end
  
  def time_factor
    430
  end
end