Yomo::Application.routes.draw do
  get "home/index"
  root :to => 'home#index'
  match "/auth/google_login/callback" => "sessions#create", via: [:get, :post]
  match "/signout" => "sessions#destroy", :as => :signout, via: [:get, :post]

  resources :videos, only: [:index, :new, :show, :create]
  
end
