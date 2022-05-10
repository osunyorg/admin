namespace :research do
  resources :researchers, only: [:index, :show]
  resources :journals do
    resources :volumes, controller: 'journals/volumes'
    resources :articles, controller: 'journals/articles' do
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
