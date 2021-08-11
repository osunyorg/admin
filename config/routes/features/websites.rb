namespace :websites do
  resources :sites
  root to: 'sites#index'
end
