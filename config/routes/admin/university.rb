namespace :university do
  resources :people, :organizations
  namespace :organization do
    resources :imports, only: [:index, :show, :new, :create]
  end
  namespace :person do
    resources :alumni
    namespace :alumnus do
      resources :imports, only: [:index, :show, :new, :create]
    end
  end
end
