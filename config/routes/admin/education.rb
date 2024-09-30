namespace :education do
  resources :academic_years
  resources :cohorts, only: [:index, :show]
  resources :diplomas do
    member do
      get :static
    end
  end
  resources :programs do
    resources :roles, controller: 'programs/roles' do
      resources :people, controller: 'programs/roles/people', only: [:destroy] do
        post :reorder, on: :collection
      end
      collection do
        post :reorder
      end
    end
    resources :teachers, controller: 'programs/teachers', only: :destroy
    collection do
      resources :categories, controller: 'programs/categories', as: 'program_categories' do
        collection do
          post :reorder
        end  
        member do
          get :children
          get :static
        end
      end
      get :tree
      post :reorder
    end
    member do
      get 'presentation' => 'programs/parts#presentation', as: :presentation
      get 'pedagogy' => 'programs/parts#pedagogy', as: :pedagogy
      get 'results' => 'programs/parts#results', as: :results
      get 'admission' => 'programs/parts#admission', as: :admission
      get 'certification' => 'programs/parts#certification', as: :certification
      get 'alumni' => 'programs/parts#alumni', as: :alumni
      get :children
      get :preview
      get :static
    end
  end
  resources :schools do
    resources :roles, controller: 'schools/roles' do
      resources :people, controller: 'schools/roles/people', only: [:destroy] do
        post :reorder, on: :collection
      end
      collection do
        post :reorder
      end
    end
    member do
      get :static
    end
  end
  resources :teachers, only: [:index, :show, :edit, :update] do
    member do
      get :static
    end
  end
  root to: 'dashboard#index'
end
