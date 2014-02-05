class Building < ActiveRecord::Base
  belongs_to :city
  
  validates :city_id, presence: true
  validates :level, presence: true, numericality: { greater_than: 0 }
  validates :type, presence: true
  validate :valid_type
  
  def cast
    becomes type.constantize
  end
  
  def as_json(methods)
    JSON.parse to_s
  end
  
  def to_s
    Jbuilder.new do |json|
      json.(self, :id, :level, :type, :energy_consumption, :upgrade_resources)
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
  
  def energy_consumption
    stub "Energieverbrauch fehlt"
  end
  
  def upgrade_resources
    Resources.new silicon: 50, plastic: 50, graphite: 50
  end
  
  def consume_resources
    resources = city.resources
    if resources >= upgrade_resources
      yield if block_given?
      if valid?
        resources.subtract(upgrade_resources).save
        return true
      end
    else
      errors.add :missing_resources, upgrade_resources.subtract_to_zero(resources)
    end
    false
  end
  
  def self.build(city, params)
    building = city.buildings.new(params.merge(level: 1))
    return building, false unless building.valid?
    return building, if building.consume_resources then building.save else false end
  end
  
  # diese Funktionen sind unabhängig vom Gebäudetyp
  def upgrade!
    if consume_resources { write_attribute :level, level + 1 }
      save
      self
    else
      errors
    end
  end
  
  def downgrade!
    write_attribute :level, level - 1
    if save
      self
    else
      errors
    end
  end
  
  # alle erlaubten Gebäudetypen zurückgeben
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
  
  # alle erlaubten Gebäudetypen als Baumstruktur zurückgeben
  def self.valid_types_tree
    tree = { EnergyBuilding: [], ResourceBuilding: [], SpecialBuilding: [] }
    self.valid_types.map do |type|
      tree[type.constantize.superclass.to_s.to_sym].push type
    end
    tree
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
  
end