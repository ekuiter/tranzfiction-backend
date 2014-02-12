class City < ActiveRecord::Base
  belongs_to :user
  has_many :buildings
  has_one :resources
  
  validates :user, presence: true
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }, uniqueness: { scope: :user_id }
  validate :city_limit
  
  before_create :create_resources

  def as_json(methods)
    JSON.parse to_s
  end
  
  def to_s
    Jbuilder.new do |json|
      json.(self, :id, :name, :build_speed, :resources)
    end.target!
  end
  
  def reset
    if buildings.destroy_all
      self
    else
      errors
    end
  end
  
  def build_speed
    hqbuilding = buildings.where(type: "HQBuilding").first
    return 1 unless hqbuilding
    if hqbuilding.ready?
      hqbuilding.affect_build_speed
    else
      hqbuilding.affect_build_speed level: hqbuilding.level - 1
    end
  end
  
  def ready_buildings
    buildings.map.select do |building|
      building.ready?
    end
  end
  
  private
  
  def create_resources
    assign_attributes resources: Resources.create(silicon: 500, plastic: 500, graphite: 500) unless resources
  end
  
  def city_limit
    return unless user
    limit = user.city_limit
    cities = limit == 1 ? "Stadt" : "Städte"
    errors.add(:base, "Du darfst nur #{limit} #{cities} haben") if user.cities.count >= limit
  end
end
