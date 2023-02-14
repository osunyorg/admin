namespace :university do
  # Resources must come after namespaces, otherwise there is a confusion with ids
  namespace :organizations do
    resources :imports, only: [:index, :show, :new, :create]
  end
  namespace :alumni do
    namespace :cohorts do
      resources :imports, only: [:index, :show, :new, :create]
    end
    namespace :experiences do
      resources :imports, only: [:index, :show, :new, :create]
    end
  end
  resources :alumni, only: [:index, :show] do
    member do
      get 'cohorts' => 'alumni/cohorts#edit'
      patch 'cohorts' => 'alumni/cohorts#update'
      get 'experiences' => 'alumni/experiences#edit'
      patch 'experiences' => 'alumni/experiences#update'
    end
  end
  resources :people do
    member do
      get :static
      get "/translations/:lang" => "people#in_language", as: :show_in_language
    end
  end
  resources :organizations do
    collection do 
      get :search, defaults: { format: 'json' }
    end
    member do
      get :static
    end
  end
  root to: 'dashboard#index'
end
