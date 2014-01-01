class EducationBuilding < SpecialBuilding
  def title
    case level
      when 1..2 then "Grundschule"
      when 3..4 then "Gymnasium"
      when 5..infinity then "Universität"
    end
  end
end