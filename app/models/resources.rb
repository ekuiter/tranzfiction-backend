class Resources < ActiveRecord::Base
  belongs_to :city
  
  validates :silicon, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 1000000 }
  validates :plastic, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 1000000 }
  validates :graphite, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 1000000 }
  
  def self.new(hash={})
    instance = super(hash)
    hash ||= {}
    hash[:silicon] ||= 0
    hash[:plastic] ||= 0
    hash[:graphite] ||= 0
    instance.silicon, instance.plastic, instance.graphite = hash[:silicon], hash[:plastic], hash[:graphite]
    instance
  end
  
  def as_json(methods=nil, type=:integer)
    JSON.parse to_s(type)
  end
  
  def to_s(type=:integer)
    Jbuilder.new do |json|
      if type == :float
        json.silicon silicon.to_f
        json.plastic plastic.to_f
        json.graphite graphite.to_f
      elsif type == :integer
        json.silicon silicon.floor
        json.plastic plastic.floor
        json.graphite graphite.floor
      end
    end.target!
  end
  
  def gain(resource, amount)
    resource_symbol = resource.to_sym
    current_amount = send(resource_symbol)
    assign_attributes resource_symbol => current_amount + amount
    self
  end
  
  def add(resources)
    raise ArgumentError unless resources.is_a? Resources
    write_attribute(:silicon, silicon + resources.silicon)
    write_attribute(:plastic, plastic + resources.plastic)
    write_attribute(:graphite, graphite + resources.graphite)
    self
  end
  
  def subtract(resources)
    raise ArgumentError unless resources.is_a? Resources
    write_attribute(:silicon, silicon - resources.silicon)
    write_attribute(:plastic, plastic - resources.plastic)
    write_attribute(:graphite, graphite - resources.graphite)
    self
  end
  
  def subtract_to_zero(resources)
    subtract resources
    write_attribute(:silicon, 0) if read_attribute(:silicon) < 0
    write_attribute(:plastic, 0) if read_attribute(:plastic) < 0
    write_attribute(:graphite, 0) if read_attribute(:graphite) < 0
    self
  end
  
  def +(resources)
    dup.add resources
  end
  
  def -(resources)
    dup.subtract resources
  end
  
  def equals(resources)
    raise ArgumentError unless resources.is_a? Resources
    silicon == resources.silicon and plastic == resources.plastic and graphite == resources.graphite
  end
  
  def greater_than(resources)
    raise ArgumentError unless resources.is_a? Resources
    silicon > resources.silicon and plastic > resources.plastic and graphite > resources.graphite
  end
  
  def greater_than_or_equals(resources)
    raise ArgumentError unless resources.is_a? Resources
    silicon >= resources.silicon and plastic >= resources.plastic and graphite >= resources.graphite
  end
  
  def less_than(resources)
    raise ArgumentError unless resources.is_a? Resources
    resources.greater_than self
  end
  
  def less_than_or_equals(resources)
    raise ArgumentError unless resources.is_a? Resources
    resources.greater_than_or_equals self
  end
  
  def ==(resources)
    equals resources
  end
  
  def !=(resources)
    not equals resources
  end
  
  def >(resources)
    greater_than resources
  end
  
  def >=(resources)
    greater_than_or_equals resources
  end
  
  def <(resources)
    less_than resources
  end
  
  def <=(resources)
    less_than_or_equals resources
  end
  
  def self.empty
    Resources.new silicon: 0, plastic: 0, graphite: 0
  end
  
  def empty!
    write_attribute(:silicon, 0)
    write_attribute(:plastic, 0)
    write_attribute(:graphite, 0)
    save
  end
end
