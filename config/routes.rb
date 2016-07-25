Rails.application.routes.draw do
  root 'users#show'
  devise_for :users

  resources :users do
    resources :vehicles do
      resources :park_records, only: [:new, :create, :edit, :update]
    end
  end

  resources :locations do
    resources :slots do
    end
    resources :park_records, only: [:index, :new, :create]
    get '/park_records/simulate', to: 'park_records#simulate', as: :simulate_parking
    post '/park_records/park', to: 'park_records#park', as: :use_slots
    put '/park_records/leave', to: 'park_records#leave', as: :leave_slots
  end
end
