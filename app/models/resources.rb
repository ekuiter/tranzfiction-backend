class Resources < ActiveRecord::Base
  belongs_to :city
  
  validates :silicon, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 1000000 }
  validates :plastic, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 1000000 }
  validates :graphite, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 1000000 }
  
  def as_json(methods, type=:integer)
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
  
  def +(resources)
    result = dup
    result.silicon  += resources.silicon
    result.plastic  += resources.plastic
    result.graphite += resources.graphite
    result
  end
  
  def -(resources)
    result = dup
    result.silicon  -= resources.silicon
    result.plastic  -= resources.plastic
    result.graphite -= resources.graphite
    result
  end
end
