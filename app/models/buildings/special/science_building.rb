class ScienceBuilding < SpecialBuilding
  def title
    case level
      when 1..2 then "Labor"
      when 3..4 then "Institut"
      when 5..6 then "KERN"
      when 7..infinity then "NAZA"
    end
  end
end