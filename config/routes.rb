Rails.application.routes.draw do
  root 'home#index'
  namespace :admin do
    root to: 'dashboards#index'
    patch 'animes/switch_public', to: 'animes#switch_public'
    resources :animes, shallow: true do
      scope module: :animes do
        scope :animes, as: :anime do
          resources :episodes, only: %w[destroy] do
            resources :tweets, only: %w[index], module: :episodes
            resources :tweets_imports, only: %w[new create], module: :episodes
          end
        end
        resource :episodes, only: %w[edit update]
        resource :terms, only: %w[edit update]
      end
    end
    resources :users
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
