class City < ActiveRecord::Base
  belongs_to :user
  has_many :buildings
  
  validates :user, presence: true
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }, uniqueness: { scope: :user_id }
  validate :city_limit
  
  def as_json(methods)
    JSON.parse to_s
  end
  
  def to_s
    Jbuilder.new do |json|
      json.(self, :id, :name, :build_speed)
    end.target!
  end
  
  private
  
  def city_limit
    limit = user.city_limit
    cities = limit == 1 ? "Stadt" : "Städte"
    errors.add(:base, "du darfst nur #{limit} #{cities} bauen") if user.city_count >= limit
  end
  
  def build_speed
    Defaults::City::build_speed
  end
end
