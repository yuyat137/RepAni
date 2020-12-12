Rails.application.routes.draw do
  root 'home#index'
  namespace :admin do
    root to: 'dashboards#index'
    patch 'animes/switch_public', to: 'animes#switch_public'
    namespace :animes do
      resources :terms, only: %w[edit update], param: :anime_id
      resources :episodes, only: %w[edit update], param: :anime_id
      resources :episodes, only: %w[destroy], param: :episode_id
      resources :tweets, only: %w[index]
      resources 'import_tweets', only: %w[show], param: :episode_id
      post 'import_tweets/import', to: 'import_tweets#import'
    end
    resources :animes
    resources :episodes, only: %w[index]
    resources :terms, only: %w[edit update]
    resources :animes_imports, only: %w[new create]
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
