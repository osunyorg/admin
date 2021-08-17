namespace :server do
  resources :universities
  root to: 'dashboard#index'
end
