class Resources < ActiveRecord::Base
  belongs_to :city
  
  validates :silicon, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 1000000 }
  validates :plastic, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 1000000 }
  validates :graphite, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 1000000 }
  
  def as_json(methods)
    JSON.parse to_s
  end
  
  def to_s
    Jbuilder.new do |json|
      json.silicon silicon.floor
      json.plastic plastic.floor
      json.graphite graphite.floor
    end.target!
  end
  
  def gain(resource, amount)
    resource_symbol = resource.to_sym
    current_amount = send(resource_symbol)
    assign_attributes resource_symbol => current_amount + amount
    self
  end
end
