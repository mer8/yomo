Yomo::Application.routes.draw do
  get "home/index"
  root :to => 'home#index'
  match "/auth/google_login/callback" => "sessions#create", via: [:get, :post]
  match "/signout" => "sessions#destroy", :as => :signout, via: [:get, :post]
  get "sessions" => 'sessions#index'
  resources :videos, only: [:index, :new, :show, :create]
  get 'contact/new' => 'contact#new'
  post 'contact' => 'contact#create'
  
end
