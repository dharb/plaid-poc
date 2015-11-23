Rails.application.routes.draw do
  root to: 'users#index'
  devise_for :users
  resources :users do
    member do
      get :select_bank
      get :institutions
    end
  end
end
