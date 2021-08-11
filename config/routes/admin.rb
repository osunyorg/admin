namespace :admin do
  resources :universities
  resources :users

  namespace :features, path: '' do
    Feature.all.each do |feature|
      draw "admin/features/#{feature}"
    end
  end

  root to: 'dashboard#index'
end
