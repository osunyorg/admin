namespace :server do
  resources :universities
  resources :languages
  resources :tags
  resources :websites do
    collection do
      post :clean_and_rebuild_all_websites
    end
    member do
      post :analyse
      post :clean_and_rebuild
      post :sync_theme_version
      post :unlock_for_background_jobs
      post :update_theme
    end
  end
  resources :blocks, only: [:index, :show]
  resources :optin_users, only: :index
  resources :emergency_messages do
    member do
      post :deliver
    end
  end
  get 'background-jobs' => 'background_jobs#index', as: :background_jobs
  get 'overrides' => 'overrides#index'
  get 'overrides/show' => 'overrides#show', as: :override
  post 'overrides' => 'overrides#analyse', as: :analyse_overrides
  root to: 'dashboard#index'
end
