module Defaults
  module User
    def self.city_limit
      3
    end
    
    def self.registerable
      false
    end
  end
  
  module Routes
    def self.frontend_url
      "http://tranzfiction.com/"
    end
  end
  
  module Worker
    def self.password
      if Rails.env.production?
        ENV['WORKER_PASSWORD']
      else
        config = HashWithIndifferentAccess.new(YAML.load(File.read(Rails.root.join("config", "database.yml"))))
        config[:worker_password]
      end
    end
  end
end
