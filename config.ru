# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application

use Rack::Cors do
  allow do
    origins 'sf.elias-kuiter.de'
    resource '*'
  end
end