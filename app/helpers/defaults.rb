module Defaults
  module User
    def self.city_limit
      3
    end
    
    def self.registerable
      false
    end
  end
  
  module City
    def self.build_speed
      1
    end
  end
  
  module Building
    def self.gain_interval
      5 # alle 5 Sekunden
    end
  end
  
  module Routes
    def self.frontend_url
      "http://tranzfiction.com/"
    end
  end
  
  module Worker
    def self.pass
      config = HashWithIndifferentAccess.new(YAML.load(File.read(Rails.root.join("config", "database.yml"))))
      config[:worker_pass]
    end
  end
end
