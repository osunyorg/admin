namespace :education do
  resources :teachers, except: [:create, :destroy]
  resources :schools
  resources :programs do
    collection do
      post :reorder
    end
    member do
      get :children
    end
  end
end
