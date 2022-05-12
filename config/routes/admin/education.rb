namespace :education do
  resources :teachers, only: [:index, :show, :edit, :update]
  resources :schools do
    resources :roles, controller: 'schools/roles' do
      resources :people, controller: 'schools/roles/people', only: [:destroy] do
        post :reorder, on: :collection
      end
      collection do
        post :reorder
      end
    end
  end
  resources :programs do
    resources :roles, controller: 'programs/roles' do
      resources :people, controller: 'programs/role/people', only: [:destroy] do
        post :reorder, on: :collection
      end
      collection do
        post :reorder
      end
    end
    resources :teachers, controller: 'programs/teachers', except: :show do
      collection do
        post :reorder
      end
    end
    collection do
      post :reorder
    end
    member do
      get :children
    end
  end
  resources :academic_years
  resources :cohorts
end
