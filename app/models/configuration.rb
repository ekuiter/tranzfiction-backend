class Configuration < ActiveRecord::Base
  validates :key, presence: true, uniqueness: true
  validates :value, presence: true
  
  def self.last_gain
    last_gain = where(key: "last_gain").first
    if last_gain
      last_gain.value.to_time
    else
      Time.now - 1 # nur ein Standardwert, falls last_gain noch nicht gesetzt wurde
    end
  end
  
  def self.last_gain=(time)
    last_gain = where(key: "last_gain").first
    last_gain ||= new(key: "last_gain")
    last_gain.value = time.to_s(:db)
    last_gain.save
  end
  
  def self.since_last_gain
    time = last_gain
    Time.now - time if time
  end
end
