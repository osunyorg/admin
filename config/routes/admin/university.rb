namespace :university do
  resources :people, :organizations
  namespace :organization do
    resources :imports, only: [:index, :show, :new, :create]
  end
  namespace :person do
    resources :alumni, only: [:index, :show] do
      member do
        get 'edit_cohorts' => 'alumni#edit_cohorts'
        patch 'edit_cohorts' => 'alumni#update_cohorts'
        get 'edit_experience' => 'alumni#edit_experiences'
        patch 'edit_experiences' => 'alumni#update_experiences'
      end
    end
    namespace :alumnus do
      resources :imports, only: [:index, :show, :new, :create]
    end
  end
end
