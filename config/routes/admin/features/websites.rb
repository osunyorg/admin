namespace :websites do
  resources :sites
  get 'dashboard' => 'dashboard#index', as: :dashboard
end
