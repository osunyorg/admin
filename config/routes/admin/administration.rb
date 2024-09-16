namespace :administration do
  namespace :alumni do
    namespace :cohorts do
      resources :imports, only: [:index, :show, :new, :create]
    end
  end
  resources :alumni, only: [:index, :show] do
    member do
      get 'cohorts' => 'alumni/cohorts#edit'
      patch 'cohorts' => 'alumni/cohorts#update'
    end
  end
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
