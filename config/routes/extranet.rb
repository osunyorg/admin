namespace :university do
  resources :organizations, only: [:index, :show]
end
