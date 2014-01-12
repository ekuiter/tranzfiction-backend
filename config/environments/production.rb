Tranzfiction::Application.configure do  
  
  # Zusätzliche Einstellungen
  # =====================
    
  config.session_store :cookie_store, 
    key: '_tranzfiction_session', # das Session-Cookie _tranzfiction_session ...
    domain: ".tranzfiction.com", # ... gilt nicht nur für api.tranzfiction.com, sondern auch für (www.)tranzfiction.com, also das Frontend
    httponly: false # außerdem kann es nicht nur mit HTTP, sondern auch durch JavaScript abgerufen werden (document.cookies)
  
  # konfiguriert den Maildienst, hier Sendgrid (kostenlos für bis zu 200 E-Mails täglich)
  config.action_mailer.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => 'heroku.com',
    :enable_starttls_auto => true
  }
  # setzt den Absender der Mails
  config.action_mailer.default_url_options = { :host => 'api.tranzfiction.com' }
  
  # Standardeinstellungen
  # =====================
  
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both thread web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this).
  config.serve_static_assets = false

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Generate digests for assets URLs.
  config.assets.digest = true

  # Version of your assets, change this if you want to expire all your assets.
  config.assets.version = '1.0'

  # Set to :debug to see everything in the log.
  config.log_level = :info

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Disable automatic flushing of the log to improve performance.
  # config.autoflush_log = false

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new
end
