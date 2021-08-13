namespace :admin do
  resources :users

  namespace :features, path: '' do
    Feature.all.each do |feature|
      draw "admin/features/#{feature}"
    end
  end

  namespace :research do
    resources :journals do
      resources :volumes, controller: 'journal/volumes'
    end
  end

  root to: 'dashboard#index'
end
