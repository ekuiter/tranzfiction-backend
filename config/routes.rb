module Actions
  def self.frontend_actions 
    {
      new_city: { path: "city/new", desc: "Erstellt eine neue Stadt." },
    }
  end
  
  # Die Beschreibung der API. Wirkt sich direkt auf die verfügbaren Routen aus und wird im Backend zur Dokumentation der API genutzt.
  def self.backend_actions
    {
      user:               { path: "user",             to: "meta#user",    desc: "Zeigt Informationen zum aktuell eingeloggten Benutzer an." },
      cities:             { path: "city",             to: "city#index",   desc: "Zeigt alle deine Städte an." },
      create_city:        { path: "city/create",      to: "city#create",  desc: "Erstellt eine neue Stadt. Der Name wird als ?city[name]=*name* angehängt." },
      destroy_city:       { path: "city/:id/destroy", to: "city#destroy", desc: "Löscht die Stadt mit der ID *city_id*." },
      city:               { path: "city/:id",         to: "city#show",    desc: "Zeigt die Stadt mit der ID *city_id* an." },
      buildings:          { path: "city/:city_id/building",                      to: "building#index",   desc: "Zeigt alle Gebäude der Stadt *city_id* an." },
      create_building:    { path: "city/:city_id/building/create",               to: "building#create",  desc: "Erstellt ein neues Gebäude in der Stadt *city_id* mit dem Gebäudetyp ?building[type]=*type*." },
      destroy_building:   { path: "city/:city_id/building/:building_id/destroy", to: "building#destroy", desc: "Löscht das Gebäude *building_id* in der Stadt *city_id*." },
      building:           { path: "city/:city_id/building/:building_id",         to: "building#show",    desc: "Zeigt das Gebäude *building_id* in der Stadt *city_id* an." },
      upgrade_building:   { path: "city/:city_id/building/:building_id/upgrade", to: "building#upgrade", desc: "Erhöht das Level des Gebäudes *building_id* in der Stadt *city_id* um 1." },
      
      # zum Debuggen
      reset_city:         { path: "city/:id/reset",   to: "city#reset",   desc: "Setzt die Stadt mit der ID *city_id* zurück. (Admin-only)" },
      downgrade_building: { path: "city/:city_id/building/:building_id/downgrade", to: "building#downgrade", desc: "Verringert das Level des Gebäudes *building_id* in der Stadt *city_id* um 1. (Admin-only)" },
      
      # Worker
      gain:               { path: "gain/:password",       to: "worker#gain",  desc: "Wird automatisch alle #{Defaults::Building::gain_interval} Sekunden aufgerufen, um Rohstoffe abzubauen." }
    }
  end
end

Tranzfiction::Application.routes.draw do
  # Selbstregistrierung deaktivieren, falls so eingestellt
  unless Defaults::User::registerable
    get 'users/sign_up' => redirect('/422.html')
    post 'users' => redirect('/422.html')
  end
  
  # User-Authentifizierung (mit angepassten Login- und Registrierungscontrollern)
  devise_for :users, controllers: {
    sessions: "authentication/sessions", 
    registrations: "authentication/registrations"
  }
  
  root to: "meta#home"
  get "api", to: "meta#api", as: :api
  
  namespace :admin do
    resources :users
  end
  
  Actions::frontend_actions.each do |name, action|
    get action[:path], to: redirect(Defaults::Routes::frontend_url + action[:path]), as: name
  end
  
  Actions::backend_actions.each do |name, action|
    get action[:path], to: action[:to], as: name
  end
  
  match "(*everything)" => redirect("/"), via: :all
end
