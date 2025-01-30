Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  resources :subscriptions, only: [:index]
  resources :users, only: [:new, :create] do
    member do
      get :qr_code, action: :show_qr
    end
  end

  # Defines the root path route ("/")
  root "subscriptions#index"
end
