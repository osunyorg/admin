namespace :server do
  resources :universities
  resources :languages
  resources :tags
  resources :websites do
    collection do
      post :clean_and_rebuild_all_websites
    end
    member do
      post :sync_theme_version
      post :analyse
      post :update_theme
      post :unlock_for_background_jobs
    end
  end
  resources :blocks, only: [:index, :show] do
    post :resave, on: :member
  end
  resources :emergency_messages do
    member do
      post :deliver
    end
  end
  get 'overrides' => 'overrides#index'
  get 'overrides/show' => 'overrides#show', as: :override
  root to: 'dashboard#index'
end
