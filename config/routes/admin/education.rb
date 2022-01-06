namespace :education do
  resources :teachers, only: [:index, :show]
  resources :schools
  resources :programs do
    resources :roles, controller: 'program/roles', except: :index
    resources :teachers, controller: 'program/teachers', except: [:index, :show]
    collection do
      post :reorder
    end
    member do
      get :children
    end
  end
end
