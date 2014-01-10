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
  
  module Routes
    def self.frontend_url
      "http://tranzfiction.com/"
    end
  end
  
end
