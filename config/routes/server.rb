namespace :server do
  resources :universities
  resources :languages
  resources :websites, only: :index do
    member do
      post :refresh
    end
  end
  get 'blocks' => 'blocks#index', as: :blocks
  get 'blocks/:id' => 'blocks#show', as: :block
  post 'blocks/:id' => 'blocks#resave', as: :resave_block
  root to: 'dashboard#index'
end
