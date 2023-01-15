namespace :research do
  resources :researchers, only: [:index, :show, :update]
  resources :publications, only: [:index, :show, :update]
  resources :journals do
    resources :volumes, controller: 'journals/volumes'
    resources :papers, controller: 'journals/papers' do
      collection do
        post :reorder
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
