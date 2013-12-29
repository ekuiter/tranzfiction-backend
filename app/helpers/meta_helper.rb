module MetaHelper
  def insert_param(action, param)
    if action[1][:path].include?(":#{param}")
      "&lt;#{param}&gt;"
    else
      nil
    end
  end
  
  def action_link(action, type)
    send("#{action[0]}_#{type}", id: insert_param(action, :id), 
                             city_id: insert_param(action, :city_id), 
                             building_id: insert_param(action, :building_id)).html_safe
  end
end
