class ScienceBuilding < SpecialBuilding
  def title
    case level
      when 1..2 then "Labor"
      when 3..4 then "Institut"
      when 5..6 then "KERN"
      when 7..infinity then "NAZA"
    end
  end
  
  def in_title
    case title
      when "NAZA" then "In der NAZA"
      else "Im #{title}"
    end
  end
  
  def description
    "#{in_title} kannst du Technologien erforschen, die dir neue Möglichkeiten eröffnen. "+
    "Je nach Technologie können neue Gebäude oder Gebäudestufen freigeschaltet werden."
  end
end