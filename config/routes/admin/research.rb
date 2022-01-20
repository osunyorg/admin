namespace :research do
  resources :researchers, only: [:index, :show]
  resources :journals do
    resources :volumes, controller: 'journal/volumes'
    resources :articles, controller: 'journal/articles' do
      collection do
        post :reorder
      end
    end
  end
  resources :laboratories do
    resources :axes, controller: 'laboratory/axes' do
      collection do
        post :reorder
      end
    end
  end
  resources :theses
end
