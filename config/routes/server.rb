namespace :server do
  resources :universities
  resources :languages
  resources :websites, only: :index do
    member do
      post :sync_theme
      post :update_theme
    end
  end
  resources :blocks, only: [:index, :show] do
    post :resave, on: :member
  end
  root to: 'dashboard#index'
end
