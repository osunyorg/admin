namespace :university do
  # Resources must come after namespaces, otherwise there is a confusion with ids
  namespace :organizations do
    resources :imports, only: [:index, :show, :new, :create]
  end
  namespace :alumni do
    namespace :cohorts do
      resources :imports, only: [:index, :show, :new, :create]
    end
  end
  resources :apps do
    post :regenerate_token, on: :member
  end
  resources :alumni, only: [:index, :show] do
    member do
      get 'cohorts' => 'alumni/cohorts#edit'
      patch 'cohorts' => 'alumni/cohorts#update'
    end
  end
  namespace :people do
    resources :imports, only: [:index, :show, :new, :create]
    namespace :experiences do
      resources :imports, only: [:index, :show, :new, :create]
    end
  end
  resources :people do
    collection do
      get :search, defaults: { format: 'json' }
      resources :categories, controller: 'people/categories', as: 'person_categories'
    end
    member do
      get :static
      get "/translations/:lang" => "people#in_language", as: :show_in_language
      get 'experiences' => 'people/experiences#edit'
      patch 'experiences' => 'people/experiences#update'
    end
  end
  
  resources :organizations do
    collection do
      get :search, defaults: { format: 'json' }
      resources :categories, controller: 'organizations/categories', as: 'organization_categories'
    end
    member do
      get :static
      get "/translations/:lang" => "organizations#in_language", as: :show_in_language
    end
  end
  root to: 'dashboard#index'
end
