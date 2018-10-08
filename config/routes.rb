Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  namespace :admin do
    get "/", to: "users#index"
    resources :users
    resources :films, except: [:show] do
      resource :review
    end
    resources :categories, except: [:show, :new]
    resources :reviews, only: [:index]
    resources :comments, only: [:index, :destroy]
  end
  root "pages#home"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  resources :users do
    resources :password_resets, only: [:edit, :update]
  end
  resources :password_resets, only: [:new, :create]
  get "signup", to: "users#new"
  post "signup", to: "users#create"

  resources :films, only: [:show, :index] do
    resource :review, only: [:show]
  end

  resources :reviews, only: [:index] do
    resources :comments, only: [:create]
  end

  resources :comments, only: [:destroy] do
    resources :comments, only: [:index, :create]
  end
  resources :ratings
  resources :categories, only: [:show]

  resources :export_films, only: [:index]
end
