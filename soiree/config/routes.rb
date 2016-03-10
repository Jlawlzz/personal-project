Rails.application.routes.draw do
  root 'home#index'
  get '/auth/spotify/callback', to: 'spotify#create'
  get '/auth/facebook/callback', to: 'sessions#create'
  get '/dashboard', to: 'dashboard#show'
  delete '/logout', to: 'sessions#destroy'

  namespace :group do
    resources :playlists, only: [:new, :create, :show, :destroy]
    resources :invites, only: [:index, :update, :destroy]
  end

  namespace :personal do
    resources :playlists, only: [:new, :create, :show, :destroy]
  end

  namespace :api do
    namespace :v1 do

      namespace :personal do
        post 'platform_playlists', to: 'platform_playlists#create'
      end

      namespace :group do
        post 'platform_playlists', to: 'platform_playlists#create'
      end

    end
  end
end
