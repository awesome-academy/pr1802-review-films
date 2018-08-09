Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  namespace :admin do
    get "/", to: "users#index"
    resources :users
    resources :films do
      resources :reviews, only: [:new, :create]
    end
    resources :categories
    resources :reviews, except: [:new, :create]
  end
  root "pages#home"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  resources :users
  get "signup", to: "users#new"
  post "signup", to: "users#create"
end
