namespace :education do
  resources :programs
  namespace :qualiopi do
    resources :criterions
    resources :indicators
  end
  get 'dashboard' => 'dashboard#index', as: :dashboard
end
