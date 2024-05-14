require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  get 'dashboard/index'
  get 'reports/balance'
  resources :payments
  devise_for :users

  resources :debts, except: %i(edit update show)

  resources :people do
    collection do
      get :search
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Mounts a Rails engine at /letter_opener to have easy access to sent emails
  # This is only available in development
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  # Mounts a Sidekiq web interface at /sidekiq
  mount Sidekiq::Web => '/sidekiq'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root 'dashboard#index'
end
