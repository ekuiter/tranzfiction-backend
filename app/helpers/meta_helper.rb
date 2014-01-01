module MetaHelper
  def insert_param(action, param)
    if action[1][:path].include?(":#{param}")
      "*#{param}*"
    else
      nil
    end
  end
  
  def action_link(action, type)
    send("#{action[0]}_#{type}", id: insert_param(action, :id), 
                             city_id: insert_param(action, :city_id), 
                             building_id: insert_param(action, :building_id)).html_safe
  end
  
  def action_dump(actions, klass)
    ret = "<table class=\"table table-striped\">
      <thead>
        <tr>
          <th>URL</th>
          <th>Funktion</th>
        </tr>
      </thead>
      <tbody>"
    actions.each do |action|
        ret += "<tr>
          <td>#{link_to action_link(action, :url), action_link(action, :path), class: klass}</td>
          <td>#{action[1][:desc]}</td>
        </tr>"
    end    
    ret += "<tbody>
    </table>"
  end
end
