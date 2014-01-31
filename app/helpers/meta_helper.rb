module MetaHelper  
  def action_link(action)
    action_name = action[0]
    action_path = action[1][:path]
    
    required_params =       # um die benötigten Parameter einer Action zu erhalten,
      action_path           # wird der Path dieser action (z.B. "city/:city_id/building/:building_id/destroy")
      .scan(/:(.*?)(\/|$)/) # mit einem regulären Ausdruck gescannt, der solche :parameter/ findet und raussucht
      .map(&:first)         # [["city_id"],["building_id"]] wird in ["city_id","building_id"] umgebaut
      .map(&:to_sym)        # ["city_id","building_id"] wird in [:city_id,:building_id] umgebaut
      
    params = Hash[          # erstelle ein assoziatives Array {}
      required_params.zip(  # bei dem die :parameter Schlüssel sind
        required_params.map {|param| "*#{param}*"} # und die *parameter* Werte
      )
    ]
    
    send("#{action_name}_path", params).html_safe
    
    # EXKURS: REGULÄRE AUSDRÜCKE
    # Wie funktioniert dieser Regex (=regular expression)?
    # /:(.*?)(\/|$)/
    # Die beiden Schrägstriche am Anfang und Ende markieren Anfang und Ende des Regex:
    # /mein_regex/
    # Es wird zunächst nach einem Doppelpunkt gesucht, um den Anfang des Parameters zu finden:
    # /:/
    # So werden die Parameteranfänge erfasst.
    # Nun wird eine beliebige Anzahl von Zeichen eingeschoben:
    #   . bedeutet ein beliebiges Zeichen
    #   * bedeutet vom vorherigen beliebig viel
    #   .* bedeutet beliebig viele beliebige Zeichen
    #   ? bedeutet dass das Endergebnis möglichst kurz ist, man sagt, der Regex ist "greedy" (=gierig)
    # Der Regex soll bis zu einem Schrägstrich suchen:
    # / 
    # Da dieser allerdings schon als Anfangs-/Ende-Indikator des Regex genutzt wird, muss er mit dem Backslash escaped werden:
    # \/    Dies trifft also auf einen Slash zu.
    # Da der Parameter nicht nur so aussehen kann:
    # ":parameter/blablabla" sonder auch so: ":parameter", muss nicht nur auf den Slash überprüft werden,
    # sondern auch das Ende der Zeichenkette. Für Ende einer Zeichenkette steht das Dollarzeichen $
    # Um die beiden Fälle zu unterscheiden, nutzt man die Pipe |
    # Diese stellt ein "oder" dar.
    # (\/|$)    Dies trifft also zu, falls ein Slash \/ vorkommt oder | das Ende der Zeichenkette $ erreicht ist.
    # Daraus ergibt sich der gesamte Regex, noch einmal erklärt:
    # /       :              (.*?)                           (\/|$)                                                      /
    # Anfang  Suche nach :   Es folgen bel. viele Zeichen    solange bis entw. ein / oder das Stringende erreicht ist    Ende
  end
  
  def action_dump(actions, klass=nil)
    result = 
    "<table class=\"table table-striped\">
      <thead>
        <tr>
          <th>URL</th>
          <th>Funktion</th>
        </tr>
      </thead>
      <tbody>"
    actions.each do |action|
      link = link_to(action_link(action), action_link(action), class: klass)
      result += "<tr>
        <td>#{link}</td>
        <td>#{action[1][:desc]}</td>
      </tr>"
    end    
    result += "<tbody>
    </table>"
  end
end
