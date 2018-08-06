Rails.application.routes.draw do
  root "pages#home"

  namespace :admin do
    get "/" => "users#index"
  end

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  resources :users
  get "signup", to: "users#new"
  post "signup", to: "users#create"
end
