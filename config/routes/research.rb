namespace :research do
  resources :journals do
    resources :volumes, controller: 'journal/volumes'
    resources :articles, controller: 'journal/articles'
  end
end
