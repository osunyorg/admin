namespace :administration do
  resources :locations do
    member do
      get :static
    end
  end
  namespace :qualiopi do
    resources :criterions, only: [:index, :show]
    resources :indicators, only: [:index, :show]
    root to: 'criterions#index'
  end
  root to: 'dashboard#index'
end
