namespace :research do
  resources :journals, only: [:index, :show] do
    resources :volumes, only: [:index, :show], controller: 'journal/volumes'
    resources :articles, only: [:index, :show], controller: 'journal/articles'
  end
end
