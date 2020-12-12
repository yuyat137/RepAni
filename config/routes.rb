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
      resources 'tweets_imports', only: %w[new create], param: :episode_id
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
