namespace :adminserver do
  resources :universities
  root to: 'dashboard#index'
end
