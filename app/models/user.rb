class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :trackable, :validatable, :confirmable
  
  has_many :cities
  has_many :buildings, through: :cities
         
  before_destroy :last_admin?
         
  def self.admin_count
    count = 0
    all.each do |user|
      count += 1 if user.admin?
    end
    count
  end
  
  def city_limit
    Defaults::User::city_limit
  end
  
  def city_count
    cities.count
  end
  
  private
  
  def last_admin?
    admin? && self.class.admin_count == 1 ? false : true
  end
   
end
