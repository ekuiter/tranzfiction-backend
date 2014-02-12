class SiliconBuilding < ResourceBuilding
  def resource
    :silicon
  end
  
  # Berechnen der Upgrade-Ressourcen eines Gebäudes. Anstatt die Ressourcenwerte einzeln
  # anzugeben, werden sie mit einer Formel berechnet.
  # Dazu habe ich die Ressourcen-Reihen von http://t4.answers.travian.de/index.php?aid=195
  # als Vorlage genommen. Mit einem Online-Regressions-Tool erhält man bei der Datenreihe "Holz" ...
  # (Gebäudelevel) (Ressourcen)
  # 1 100
  # 2 165
  # 3 280
  # 4 465
  # 5 780
  # 6 1300
  # 7 2170
  # 8 3625
  # 9 6050
  # 10 10105
  # 15 131230
  # 25 22140900
  # ... die Gleichung: y = 23.94321334 * e^(5.128384702*10^(-1) * x)
  # vereinfacht: y = 24 * e^(0.5x)
  # als Ruby-Code dann: 24 * e(0.5 * level)
  # da e(0.5*level) bei allen Gebäuden auftaucht, wurde es in die by_formula-Funktion verlagert,
  # sodass nur der vorstehende Faktor (hier 24) angegeben werden muss.
  
  def upgrade_resources
    # an den Faktoren erkennt man den ungefähren Ressourcen-Aufwand. Beim SiliconBuilding
    # muss bspw. nur wenig Silicon in das Upgrade investiert werden (24*e...), während
    # sehr viel Kunststoff benötigt wird (60*e...).
    Resources.by_formula level: level, efactor: 0.5, silicon: 24, plastic: 60, graphite: 30
  end
  
  # der Zeitfaktor ergibt sich ebenfalls aus einer Datenreihe, bspw.:
  # (Gebäudelevel) (Zeit in Sekunden)
  # 1 450
  # 2 920
  # 3 1670
  # 4 2880
  # 5 4800
  # 6 11880
  # 7 12810
  # 8 20690
  # 9 33310
  # 10 53500
  # 15 564120
  # 25 58461730
  # so ergibt sich die Formel time_factor * e^(0.5*level)
  # (wobei der time_factor gebäudespezifisch ist)
  
  def time_factor
    400
  end
end