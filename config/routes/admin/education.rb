namespace :education do
  resources :teachers, only: [:index, :show]
  resources :schools
  resources :programs do
    resources :roles, controller: 'program/roles', except: :index do
      resources :people, controller: 'program/role/people', except: [:index, :show, :edit, :update] do
        collection do
          post :reorder
        end
      end

      collection do
        post :reorder
      end
    end
    resources :teachers, controller: 'program/teachers', except: [:index, :show]
    collection do
      post :reorder
    end
    member do
      get :children
    end
  end
end
