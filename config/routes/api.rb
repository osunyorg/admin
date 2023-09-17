namespace :api do
  get 'lheo' => 'lheo#index', defaults: { format: :xml }
  get 'osuny' => 'osuny#index', defaults: { format: :json }
  namespace :osuny, defaults: { format: :json } do 
    get 'communication' => 'communication#index'
    namespace :communication do
      get 'websites' => 'websites#index'
      namespace :websites do
        post ':website_id/posts' => 'posts#create'
      end
    end
    get 'server' => 'server#index'
    namespace :server do
      get 'websites' => 'websites#index'
      post 'websites/theme-released' => 'websites#theme_released'
    end
  end
  root to: 'dashboard#index'
end
