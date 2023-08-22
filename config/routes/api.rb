namespace :api do
  get 'lheo' => 'lheo#index', defaults: { format: :xml }
  namespace :osuny, defaults: { format: :json } do 
    get '/' => 'root#index'
    post 'theme-released' => 'root#theme_released'
  end
  root to: 'dashboard#index'
end
