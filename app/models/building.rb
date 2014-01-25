class Building < ActiveRecord::Base
  belongs_to :city
  
  validates :city_id, presence: true
  validates :level, presence: true, numericality: { greater_than: 0 }
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
      # damit der Gebäudetyp korrekt ist, muss das Gebäude von Building abgeleitet sein (<),
      # darf aber (wie Resource-, Energy- oder SpecialBuilding) keine direkte Kindklasse sein (superclass !=).
      valid = type.constantize < Building && type.constantize.superclass != Building
    rescue
      valid = false
    end
    errors.add(:type, "ungültig") unless valid
  end
  
  private
  
  # Unendlichkeit (wird für die einzelnen Gebäudetypen benötigt)
  def infinity
    +1.0 / 0.0 # Wert der positiven Unendlichkeit in Ruby
  end
  
  # diese Funktionen sind für jeden Gebäudetyp spezifisch,
  # hier geben sie als Platzhalter Fehlermeldungen zurück
  
  def stub message
    "#{self.class.to_s}: #{message}"
  end
  
  public
  
  def title
    stub "Titel fehlt"
  end
  
  def description
    stub "Beschreibung fehlt"
  end
  
  def image
    stub "Bild fehlt"
  end
  
  def energy_consumption
    stub "Energieverbrauch fehlt"
  end
  
  def upgrade_resources
    stub "Ressourcenverbrauch fehlt"
  end
  
  def process
    raise stub("process() undefiniert")
  end
  
  # diese Funktionen sind unabhängig vom Gebäudetyp
  def upgrade
    write_attribute :level, level + 1
    if save
      self
    else
      errors
    end
  end
  
  def downgrade
    write_attribute :level, level - 1
    if save
      self
    else
      errors
    end
  end
  
  def self.valid_types
    types = []
    Dir.glob(Rails.root.join("app", "models", "buildings", "**", "*.rb").to_s) do |file|
      types.push File.basename(file, ".*")
    end
    types = types.map { |file| file.camelize }
    ["EnergyBuilding", "ResourceBuilding", "SpecialBuilding"].each do |to_delete|
      types.delete to_delete
    end
    types
  end
  
end