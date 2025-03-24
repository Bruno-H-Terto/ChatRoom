Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      root "rooms#index"
      post "sign_up", to: "sessions#sign_up", as: :sign_up, param: %i[ email password name ]
      post "sign_in", to: "sessions#sign_in", as: :sign_in, param: %i[ email password ]
      resources :rooms, only: %i[ create ] do
        resources :messages, only: %i[ index create ]
      end
      get "messages", to: "messages#history", as: :messages, param: %i[ user_id ]
    end
  end
end
