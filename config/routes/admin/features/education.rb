namespace :education do
  resources :programs
  namespace :qualiopi do
    resources :criterions, only: [:index, :show]
    resources :indicators, only: [:index, :show]
  end
  get 'dashboard' => 'dashboard#index', as: :dashboard
end
