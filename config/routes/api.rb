namespace :api do
  get 'lheo' => 'lheo#index', defaults: { format: :xml }
  get 'osuny/v1' => 'osuny#index', defaults: { format: :json }, as: :osuny
  namespace :osuny, path: 'osuny/v1', defaults: { format: :json } do 
    get 'communication' => 'communication#index'
    namespace :communication do
      get 'websites' => 'websites#index'
      namespace :websites do
        post ':website_id/events/import' => 'events#import'
        post ':website_id/posts/import' => 'posts#import'
        post ':website_id/pages/import' => 'pages#import'
      end
    end
    namespace :server do
      post 'websites/theme-released' => 'websites#theme_released'
    end
  end
  root to: 'dashboard#index'
end
