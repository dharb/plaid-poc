Rails.application.routes.draw do
  root to: 'users#index'
  devise_for :users, controllers: { registrations: "registrations"}
  resources :users do
    member do
      get :select_bank
      get :funding
      get :accounts
    end
  end
  resources :bank_accounts, only: [:create,:update]
end
