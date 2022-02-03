namespace :education do
  resources :teachers, only: [:index, :show]
  resources :schools do
    resources :roles, controller: 'school/roles' do
      resources :people, controller: 'school/role/people', only: [] do
        post :reorder, on: :collection
      end
      collection do
        post :reorder
      end
    end
  end
  resources :programs do
    resources :roles, controller: 'program/roles' do
      resources :people, controller: 'program/role/people', only: [] do
        post :reorder, on: :collection
      end
      collection do
        post :reorder
      end
    end
    resources :teachers, controller: 'program/teachers', except: :show do
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
end
