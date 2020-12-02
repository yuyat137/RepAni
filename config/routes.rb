Rails.application.routes.draw do
  root 'home#index'
  namespace :admin do
    root to: 'dashboards#index'
    patch 'animes/switch_public', to: 'animes#switch_public'
    resources :animes, only: %w[index update edit show destroy], shallow: true do
      scope module: :animes do
        resource :terms, only: %w[edit update]
        resource :episodes, only: %w[edit update]
        resources :episodes, only: %w[destroy], param: :episode_id, as: 'anime_episodes'
        post 'import_tweets/import/:episode_id', to: 'import_tweets#import', on: :collection, as: 'import_tweets'
      end
    end
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
