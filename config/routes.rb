Rails.application.routes.draw do
  root 'home#index'
  namespace :api do
    resources :animes
  end
  get '*path', to: 'home#index'
end
