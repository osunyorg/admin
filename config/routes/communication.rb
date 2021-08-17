namespace :communication do
  resources :websites
  root to: 'websites#index'
end
