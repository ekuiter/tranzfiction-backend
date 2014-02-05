class User < ActiveRecord::Base
  # sorgt für die Nutzer-Authentifikation
  devise :database_authenticatable, :registerable, :recoverable, :trackable, :validatable, :confirmable
  
  # Bezüge zu anderen Models:
  # 1:n-Relation (ein User hat beliebig viele Cities)
  has_many :cities
   # eine City hat viele Buildings, ein User hat viele Cities => ein User hat viele Buildings (Polymorphie)
  has_many :buildings, through: :cities
         
  validates :planet, presence: true, length: { minimum: 3, maximum: 50 }
        
  # sorgt dafür, dass der letzte Administrator nicht gelöscht werden kann
  validate :validate_last_admin
  before_destroy :preserve_last_admin
  
  def as_json(methods)
    JSON.parse to_s
  end
  
  def to_s
    Jbuilder.new do |json|
      json.(self, :id, :email, :admin, :planet)
    end.target!
  end
  
  def city_limit
    Defaults::User::city_limit
  end
  
  def last_admin?
    # wenn dieser Benutzer ein Admin war und nur ein Admin vorhanden war
    admin_was and self.class.admin_count == 1 ? true : false
  end
  
  private
  
  def validate_last_admin
    # wenn dies jetzt kein Admin mehr sein soll, aber der letze Admin war
    if not admin and last_admin?
      errors.add(:base, "Der letzte Admin kann nicht gelöscht werden")
    end
  end
  
  def preserve_last_admin
    !last_admin? # gibt false zurück, falls dies der letzte Admin war, was den Löschvorgang abbricht
  end
  
  def self.admins
    where admin: true
  end
  
  def self.admin_count
    count = 0
    all.each do |user|
      count += 1 if user.admin_was == true
    end
    count
  end
end
