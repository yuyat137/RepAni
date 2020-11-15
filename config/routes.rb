Rails.application.routes.draw do
  root 'home#index'
  namespace :admin do
    root to: 'dashboards#index'
    patch 'animes/switch_public', to: 'animes#switch_public'
    resources :animes, only: %w[index update edit show destroy]
    resources :anime_terms, only: %w[edit update destroy], param: :anime_id
    resources :episodes, only: %w[index]
    resources :terms, only: %w[edit update]
    resources :import_animes, only: %w[index create]
    post 'import_animes/import', to: 'import_animes#import'
  end
  namespace :api do
    resources :animes, only: %w[index]
    resources :terms, only: %w[index]
    resources :tweets, only: %w[index]
    resources :episodes, only: %w[index] do
      collection do
        get 'info'
      end
    end
  end
  get '*path', to: 'home#index'
end
