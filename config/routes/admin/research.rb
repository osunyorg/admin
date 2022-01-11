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
end
