class Building < ActiveRecord::Base
  belongs_to :city
  
  validates :city_id, presence: true
  validates :level, presence: true
  validates :type, presence: true
  validate :valid_type
  
  def as_json(methods)
    JSON.parse to_s
  end
  
  def to_s
    Jbuilder.new do |json|
      json.(self, :id, :level, :type, :title, :description, :image, :energy_consumption, :upgrade_resources)
    end.target!
  end
  
  def valid_type
    begin
      # damit der Gebäudetyp korrekt ist, muss das Gebäude von Building abgeleitet sein,
      # darf aber (wie Resource-, Energy- oder SpecialBuilding) keine direkte Kindklasse sein.
      valid = type.constantize < Building && type.constantize.superclass != Building
    rescue
      valid = false
    end
    errors.add(:type, "ungültig") unless valid
  end
  
  # Unendlichkeit (wird für die einzelnen Gebäudetypen benötigt)
  def infinity
    +1.0 / 0.0 # Wert der positiven Unendlichkeit in Ruby
  end
  
  # diese Funktionen sind für jeden Gebäudetyp spezifisch,
  # hier geben sie als Platzhalter Fehlermeldungen zurück
  
  def title
    "Titel fehlt"
  end
  
  def description
    "Beschreibung fehlt"
  end
  
  def image
    "Bild fehlt"
  end
  
  def energy_consumption
    "Energieverbrauch fehlt"
  end
  
  def upgrade_resources
    "Ressourcenverbrauch fehlt"
  end
  
  def process
    stub("process() undefiniert")
  end
  
  def upgrade
    stub("upgrade() undefiniert")
  end
  
end