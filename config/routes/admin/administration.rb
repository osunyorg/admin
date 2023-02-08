namespace :administration do
  namespace :qualiopi do
    resources :criterions, only: [:index, :show]
    resources :indicators, only: [:index, :show]
  end
  root to: 'application#index'
end
