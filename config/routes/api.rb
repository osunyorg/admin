namespace :api do
  get 'lheo' => 'lheo#index', defaults: { format: :xml }
  # v0
  get 'osuny' => '/api/osuny#redirect_to_v1' # redirect to v1
  post 'osuny/websites/theme-released' => '/api/osuny/server/websites#theme_released', defaults: {format: :json}
  # v1
  namespace :osuny, path: 'osuny/v1', defaults: { format: :json } do
    namespace :communication do
      resources :websites, only: [:index, :show] do
        resources :events, controller: 'websites/events', only: [:index, :show, :create, :update]
        resources :pages, controller: 'websites/pages', only: [:index, :show, :create, :update]
        resources :posts, controller: 'websites/posts', only: [:index, :show, :create, :update, :destroy]
        resources :projects, controller: 'websites/projects', only: [:index, :show, :create, :update]
      end
      root to: '/api/osuny/communication#index'#, controller: '/api/osuny/communication'
    end
    root to: '/api/osuny#index'
  end
  root to: 'dashboard#index'
end
