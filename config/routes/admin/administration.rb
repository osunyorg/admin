namespace :administration do
  namespace :qualiopi do
    resources :criterions, only: [:index, :show]
    resources :indicators, only: [:index, :show]
    root to: 'criterions#index'
  end
  root to: 'dashboard#index'
end
