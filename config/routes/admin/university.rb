namespace :university do
  # Resources must come after namespaces, otherwise there is a confusion with ids
  namespace :organizations do
    resources :imports, only: [:index, :show, :new, :create]
  end
  namespace :people do
    namespace :alumni do
      resources :imports, only: [:index, :show, :new, :create]
    end
    resources :alumni, only: [:index, :show] do
      member do
        get 'edit_cohorts' => 'alumni#edit_cohorts'
        patch 'edit_cohorts' => 'alumni#update_cohorts'
        get 'edit_experience' => 'alumni#edit_experiences'
        patch 'edit_experiences' => 'alumni#update_experiences'
      end
    end
  end
  resources :people, :organizations
end
