# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application

# CORS = Cross-Origin Resource Sharing => sorgt dafür, dass AJAX-Anfragen von (www.)tranzfiction.com an api.tranzfiction.com erlaubt sind
# siehe: Same-Origin-Policy
use Rack::Cors do
  allow do
    origins ['tranzfiction.com', 'www.tranzfiction.com']
    resource '*'
  end
end