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
      json.(self, :id, :level, :type)
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
  
end