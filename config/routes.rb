Rails.application.routes.draw do
  devise_for :users

  draw 'admin'

  resources :programs, only: [:index, :show]

  root to: 'home#index'
end
