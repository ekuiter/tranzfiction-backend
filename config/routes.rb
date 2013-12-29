module Actions
  def self.frontend_url
    "http://sf.elias-kuiter.de/"
  end
  
  def self.frontend_actions 
    {
      new_city: "city/new",
    }
  end
  
  def self.backend_actions
    {
      cities:          { path: "city", to: "city#index", desc: "Zeigt alle deine Städte an." },
      create_city:     { path: "city/create", to: "city#create", desc: "Erstellt eine neue Stadt. Der Name wird als ?city[name]=<name> angehängt." },
      city:            { path: "city/:id", to: "city#show", desc: "Zeigt die Stadt mit der ID <city_id> an." },
      buildings:       { path: "city/:city_id/building", to: "building#index", desc: "Zeigt alle Gebäude der Stadt <city_id> an." },
      create_building: { path: "city/:city_id/building/create", to: "building#create", desc: "Erstellt ein neues Gebäude in der Stadt <id> mit dem Gebäudetyp ?building[type]=<type>. *" },
      building:        { path: "city/:city_id/building/:building_id", to: "building#show", desc: "Zeigt das Gebäude <building_id> in der Stadt <city_id> an." },
    }
  end
end

Tranzfiction::Application.routes.draw do
  devise_for :users, :controllers => {sessions: "sessions", registrations: "registrations"}
  
  root to: "meta#home"
  
  namespace :admin do
    get "status", to: "status#status", as: :status
    resources :users
  end
  
  Actions::frontend_actions.each do |name, path|
    get path, to: redirect(Actions::frontend_url + path), as: name
  end
  
  Actions::backend_actions.each do |name, action|
    get action[:path], to: action[:to], as: name
  end
  
  match "(*everything)" => redirect("/"), via: :all
end
