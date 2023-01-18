namespace :research do
  resources :researchers, only: [:index, :show]
  resources :journals do
    resources :volumes, controller: 'journals/volumes' do
      member do
        get :static
      end
    end
    resources :papers, controller: 'journals/papers' do
      collection do
        post :reorder
      end
      member do
        get :static
      end
    end
    resources :paper_kinds, controller: 'journals/paper_kinds' do
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
end
