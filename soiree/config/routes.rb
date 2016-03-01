Rails.application.routes.draw do
  root 'home#index'
  get '/auth/spotify/callback/', to: 'sessions#create'
  get '/auth/facebook/callback', to: 'sessions#create'
  get '/dashboard', to: 'dashboard#show'
  delete '/logout', to: 'sessions#destroy'
  resources :spotify, only: ["create"]
end
