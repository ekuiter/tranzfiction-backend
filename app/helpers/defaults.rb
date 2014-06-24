module Defaults
  module User
    def self.city_limit
      3
    end
    
    def self.registerable
      true
    end
  end
  
  module Routes
    def self.frontend_url
      "http://tranzfiction.com/"
    end
  end
end
