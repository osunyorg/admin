Rails.application.routes.draw do
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    unlocks: 'users/unlocks'
  }

  resources :languages

  namespace :admin do
    resources :users
    draw 'education'
    draw 'research'
    draw 'communication'
    draw 'administration'
    root to: 'dashboard#index'
  end

  namespace :server do
    resources :universities
    resources :languages
    root to: 'dashboard#index'
  end

  root to: 'admin/dashboard#index'
end
