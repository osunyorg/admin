namespace :education do
  resources :teachers, only: [:index, :show]
  resources :schools
  resources :programs do
    resources :teachers, controller: 'program/teachers', except: [:index, :show]
    collection do
      post :reorder
    end
    member do
      get :children
    end
  end
end
