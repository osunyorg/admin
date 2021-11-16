namespace :education do
  resources :teachers, :schools
  resources :programs do
    collection do
      post :reorder
    end
    member do
      get :children
    end
  end
end
