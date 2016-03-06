Rails.application.routes.draw do
  root 'home#index'
  get '/auth/spotify/callback', to: 'spotify#create'
  get '/auth/facebook/callback', to: 'sessions#create'
  get '/dashboard', to: 'dashboard#show'
  delete '/logout', to: 'sessions#destroy'

  namespace :group do
    resources :playlists, only: [:new, :create, :show]
  end

  namespace :personal do
    resources :playlists, only: [:new, :create, :show, :destroy]
  end
end
