Rails.application.routes.draw do
  root 'home#index'
  namespace :api do
    resources :animes, only: %w[index]
    resources :terms, only: %w[index]
    resources :tweets, only: %w[index]
    resources :episodes, only: %w[index show] do
      collection do
        get 'info'
      end
    end
  end
  get '*path', to: 'home#index'
end
