namespace :server do
  resources :universities
  resources :languages
  resources :websites, only: :index do
    post :refresh, on: :member
  end
  resources :blocks, only: [:index, :show] do
    post :resave, on: :member
  end
  root to: 'dashboard#index'
end
