namespace :education do
  resources :programs
  root to: 'programs#index'
end
