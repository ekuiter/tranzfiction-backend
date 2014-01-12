source 'https://rubygems.org'  # Quelle der Gems
ruby '2.0.0'                   # aktuelle Ruby-Version

gem 'rails',        '4.0.0'    # Ruby on Rails
gem 'rails_12factor'           # Anpassungen für Rails 4 auf Heroku
gem 'unicorn'                  # Webserver, der mehrere Anfragen zugleich unterstützt
gem 'pg'                       # Heroku PostgreSQL-Datenbank
gem 'sqlite3'                  # SQLite-Datenbank fürs Testen
gem 'sass-rails',   '~> 4.0.0' # SASS zu CSS kompilieren
gem 'coffee-rails', '~> 4.0.0' # CoffeeScript zu JavaScript kompilieren
gem 'uglifier',     '>= 1.3.0' # JavaScript komprimieren
gem 'jquery-rails'             # jQuery einbinden
gem 'turbolinks'               # Turbolinks einbinden
gem 'jbuilder',     '~> 1.2'   # für die JSON-API
gem 'devise'                   # Login-/Registrierungs-System
gem 'bootstrap-sass'           # Twitter Bootstrap für die Benutzeroberfläche
gem 'rack-cors', :require => 'rack/cors' # AJAX zulassen von (www.)tranzfiction.com auf api.tranzfiction.com

group :development do          # in der Entwicklungsumgebung:
  gem 'rails_layout'           # Bootstrap einrichten
end

group :doc do                  # für Dokumentation:
  gem 'sdoc', require: false   # bundle exec rake doc:rails
end

group :development, :test do   # beim Testen und in der Entwicklung:
  gem 'rspec-rails'            # Test-Framework RSpec
  gem 'factory_girl_rails'     # App mit Testdaten füttern
end
  
group :test do                 # nur beim Testen:
  gem 'faker'                  # Testnamen-, E-Mail-Adressen erstellen
  gem 'capybara'               # Nutzereingaben simulieren
  gem 'guard-rspec'            # Tests automatisch ausführen
  gem 'launchy'                # Browser öffnen bei fehlgeschlagenen Tests
end