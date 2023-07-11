namespace :research do
  resources :researchers, only: [:index, :show, :update] do 
    member do
      post 'sync-with-hal' => 'researchers#sync_with_hal', as: :sync_with_hal
    end
  end
  namespace :hal do
    resources :authors, only: [:index, :show, :destroy] do
      member do
        post 'researchers/:researcher_id' => 'authors#connect_researcher', as: :researcher
        delete 'researchers/:researcher_id' => 'authors#disconnect_researcher'
      end
    end
    resources :publications, only: [:index, :show, :destroy] do
      member do
        get :static
      end
    end
    root to: 'dashboard#index'
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
