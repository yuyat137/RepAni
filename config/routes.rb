Rails.application.routes.draw do
  root 'home#index'
  namespace :api do
    resources :animes, only: %w[index]
    resources :terms, only: %w[index]
  end
  get '*path', to: 'home#index'
end
