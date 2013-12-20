Tranzfiction::Application.routes.draw do
  devise_for :users
  
  root to: "meta#home"
  
  namespace :admin do
    get "status", to: "status#status", as: :status
    resources :users
  end
  
  match "(*everything)" => redirect("/"), via: :all
end
