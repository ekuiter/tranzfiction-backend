class Resources < ActiveRecord::Base
  belongs_to :city
  
  validates :silicon, presence: true, numericality: { greater_than: 0 }
  validates :plastic, presence: true, numericality: { greater_than: 0 }
  validates :graphite, presence: true, numericality: { greater_than: 0 }
end
