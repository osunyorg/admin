namespace :university do
  resources :people, :organizations
  namespace :organization do
    resources :imports, only: [:index, :show, :new, :create]
  end
end
