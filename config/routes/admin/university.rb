namespace :university do
  # Resources must come after namespaces, otherwise there is a confusion with ids
  namespace :organizations do
    resources :imports, only: [:index, :show, :new, :create]
  end
  namespace :people do
    namespace :alumni do
      resources :imports, only: [:index, :show, :new, :create]
    end
    resources :alumni
  end
  resources :people, :organizations
end
