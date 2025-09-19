Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }
  root "home#index"

  # Language switching
  patch "/set_language", to: "application#set_language", as: :set_language

  # Mount Action Cable server
  mount ActionCable.server => "/cable"

  resources :rooms do
    resources :messages, only: [ :create ]
  end

  resources :users, only: [ :show, :edit, :update ] do
    member do
      get :profile
    end
  end

  # Admin routes
  namespace :admin do
    resources :dashboard, only: [ :index ]
    resources :users do
      member do
        patch :toggle_admin
        patch :ban_user
        patch :unban_user
      end
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by uptime monitors and load balancers.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
