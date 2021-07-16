namespace :admin do
  resources :universities
  resources :users
  resources :programs

  namespace :qualiopi do
    resources :criterions
    resources :indicators
    root to: 'criterions#index'
  end

  root to: 'dashboard#index'
end
