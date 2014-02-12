class Building < ActiveRecord::Base
  belongs_to :city
  
  validates :city_id, presence: true
  validates :level, presence: true, numericality: { greater_than: 0 }
  validates :type, presence: true
  validate :valid_type
  
  before_create :set_ready_at
  
  def cast
    becomes type.constantize
  end
  
  def as_json(methods)
    JSON.parse to_s
  end
  
  def to_s
    Jbuilder.new do |json|
      json.(self, :id, :level, :type, :energy_consumption, :upgrade_resources)
      json.upgrade_time upgrade_time.ceil
      json.ready_in ready_in.ceil
    end.target!
  end
  
  # löst exponentielle Gleichungen à la: y = factor * e^(efactor*x)
  def self.solve_formula(hash)
    result = hash[:factor] * Math.exp(hash[:efactor] * hash[:level])
    result.round -1
  end
  
  def valid_type
    begin
      # damit der Gebäudetyp korrekt ist, muss das Gebäude von Building abgeleitet sein (<),
      # darf aber (wie Resource-, Energy- oder SpecialBuilding) keine direkte Kindklasse sein (superclass !=).
      valid = type.constantize < Building and type.constantize.superclass != Building
    rescue
      valid = false
    end
    errors.add(:type, "ungültig") unless valid
  end
  
  # fürs Erste ein fixer Energieverbrauch, der proportional mit dem Level steigt
  def energy_consumption
    level * 5
  end
  
  # Die Upgrade-Zeit wurde durch Regression berechnet (Beispiel siehe buildings/resource/silicon_building.rb).
  # Jedes Building hat durch time_factor individuelle Werte.
  def upgrade_time
    time = Building.solve_formula level: level, factor: cast.time_factor, efactor: 0.4
    time / city.build_speed
  end
  
  def ready?
    return false unless ready_at
    ready_at.past?
  end
  
  def ready_in
    unless ready? or ready_at.nil?
      ready_at - Time.now
    else
      0
    end
  end
  
  def ready_or_new_record?
    ready_in == 0
  end
  
  def set_ready_at
      write_attribute :ready_at, cast.upgrade_time.from_now
  end
  
  def consume_resources
    resources = city.resources
    upgrade_resources = cast.upgrade_resources
    if ready_or_new_record? and resources >= cast.upgrade_resources
      yield if block_given?
      if valid?
        set_ready_at
        resources.subtract(upgrade_resources).save
        return true
      end
    elsif not ready_or_new_record?
      errors.add :ready_in, ready_in
    else
      errors.add :missing_resources, cast.upgrade_resources.subtract_to_zero(resources)
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
  
end