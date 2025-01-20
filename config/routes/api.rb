namespace :api do
  get 'lheo' => 'lheo#index', defaults: { format: :xml }
  # v0
  get 'osuny' => '/api/osuny#redirect_to_v1' # redirect to v1
  post 'osuny/websites/theme-released' => '/api/osuny/server/websites#theme_released', defaults: {format: :json}
  # v1
  namespace :osuny, path: 'osuny/v1', defaults: { format: :json } do
    namespace :communication do
      resources :websites, only: [:index, :show] do
        namespace :agenda do
          resources :events, controller: '/api/osuny/communication/websites/agenda/events', only: [:index, :show, :create, :update, :destroy] do
            post :upsert, on: :collection
          end
        end
        namespace :page, path: 'pages' do
          resources :categories, controller: '/api/osuny/communication/websites/pages/categories', only: [:index, :show, :create, :update, :destroy] do
            post :upsert, on: :collection
          end
        end
        resources :pages, controller: '/api/osuny/communication/websites/pages', only: [:index, :show, :create, :update, :destroy] do
          post :upsert, on: :collection
        end
        resources :posts, controller: '/api/osuny/communication/websites/posts', only: [:index, :show, :create, :update, :destroy] do
          post :upsert, on: :collection
        end
        resources :projects, controller: '/api/osuny/communication/websites/projects', only: [:index, :show, :create, :update]
      end
      root to: '/api/osuny/communication#index'
    end
    namespace :university do
      namespace :organization, path: 'organizations' do
        resources :categories, controller: '/api/osuny/university/organizations/categories', only: [:index, :show, :create, :update, :destroy] do
          post :upsert, on: :collection
        end
      end
      resources :organizations, controller: '/api/osuny/university/organizations', only: [:index, :show, :create, :update, :destroy] do
        post :upsert, on: :collection
      end
    end
    root to: '/api/osuny#index'
  end
  root to: 'dashboard#index'
end
