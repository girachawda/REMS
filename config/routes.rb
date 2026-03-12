Rails.application.routes.draw do
  # Authentication routes
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # Portfolio/Properties
  resources :properties, only: [ :index, :show ] do
    resources :units, only: [ :show ]
  end

  # Agent availability
  resources :availabilities, only: [ :index, :new, :create ]

  # Appointments
  resources :appointments, only: [ :index, :new, :create ]

  # Root path
  root "properties#index"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
