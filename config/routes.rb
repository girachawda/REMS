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
  resources :appointments, only: [ :index, :new, :create, :update ]

  # Maintenance requests
  resources :maintenance_requests, only: [ :index, :new, :create ] do
    member do
      patch :mark_tenant_caused
      patch :close
    end
  end

  # Invoices
  resources :invoices, only: [ :index, :show, :create ] do
    member do
      patch :record_payment
      patch :mark_overdue
    end
  end

  # lease applications
  resources :lease_agreements, only: [ :index, :show, :new, :create, :update ] do
    member do
      patch :approve
      patch :reject
    end
  end

  # Lease agreements
  resources :lease_applications, only: [ :index, :show, :new, :create ] do
    member do
      patch :approve
      patch :reject
    end
  end

  # Accounts
  resources :accounts, only: [ :index, :show, :update ] do
    member do
      patch :set_discount
    end
  end

  # Payments
  resources :payments, only: [ :index, :new, :create ]

  # Invoices
  resources :invoices, only: [ :index, :show, :create ] do
    member do
      patch :record_payment
      patch :mark_overdue
    end
  end

  # Root path
  root "properties#index"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
