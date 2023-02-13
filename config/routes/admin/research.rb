namespace :research do
  resources :researchers, only: [:index, :show, :update]
  resources :publications, only: [:index, :show, :destroy] do
    member do
      get :static
    end
  end
  resources :journals do
    resources :volumes, controller: 'journals/volumes' do
      member do
        get :static
      end
    end
    resources :papers, controller: 'journals/papers' do
      collection do
        resources :kinds, controller: 'journals/papers/kinds' do
          member do
            get :static
          end
        end
        post :reorder
      end
      member do
        get :static
      end
    end
  end
  resources :laboratories do
    resources :axes, controller: 'laboratories/axes' do
      collection do
        post :reorder
      end
    end
  end
  resources :theses
  root to: 'dashboard#index'
end
