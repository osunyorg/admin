Rails.application.routes.draw do
  constraints host: ENV['OSUNY_SHOWCASE'] do
    get ':feature' => 'showcase/websites#feature',
                      as: :showcase_feature,
                      constraints: {
                        feature: /actualites|agenda|portfolio/
                      }
    get ':tag' => 'showcase/websites#tag', as: :showcase_tag
    get '/' => 'showcase/websites#index'
    get 'websites/:id' => 'showcase/websites#show', as: :showcase_website
  end
  constraints host: ENV['OSUNY_TRANSPARENCY'] do
    get '/' => 'transparency/home#index'
  end
  constraints host: ENV['OSUNY_DESIGN'] do
    get '/' => 'design/home#index'
  end

  authenticated :user, -> user { user.server_admin? } do
    mount GoodJob::Engine => 'background'
    mount PgHero::Engine => 'database'
  end
  mount Rswag::Ui::Engine => '/api/docs'
  mount Rswag::Api::Engine => '/api/docs'

  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    omniauth_callbacks: 'users/omniauth_callbacks',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    two_factor_authentication: 'users/two_factor_authentication',
    unlocks: 'users/unlocks'
  }

  devise_scope :user do
    post '/users/confirmation/resend' => 'users/confirmations#resend', as: :resend_user_confirmation
    match '/users/auth/saml/setup' => 'users/omniauth_callbacks#saml_setup', via: [:get, :post]
  end

  namespace :admin do
    scope '/:lang' do
      resources :users, except: [:new, :create] do
        post 'resend_confirmation_email' => 'users#resend_confirmation_email', on: :member
        patch 'unlock' => 'users#unlock', on: :member
      end
      get 'profile' => 'profile#edit'
      patch 'profile' => 'profile#update'
      delete 'profile' => 'profile#destroy'
      # libre_translate route
      post 'translate/:target' => 'translation#translate', as: :translate
      put 'favorite' => 'users#favorite', as: :favorite
      get 'search(/website/:website_id)(/extranet/:extranet_id)' => 'search#index', as: :search
      draw 'admin/administration'
      draw 'admin/communication'
      draw 'admin/education'
      draw 'admin/research'
      draw 'admin/university'
      root to: 'dashboard#index'
    end
    get '/' => 'dashboard#redirect_to_default_language'
  end

  get '/media/download/:signed_id' => 'media#download', as: :download_medium
  get '/media/static/:signed_id' => 'media#static'
  get '/media/:signed_id/:filename_with_transformations' => 'media#show', as: :medium
  post '/media/resize/:signed_id' => 'media#resize'

  draw 'api'
  draw 'server'

  scope module: 'extranet' do
    get 'style' => 'style#index', as: :style, constraints: { format: 'css' }
    scope '/:lang' do
      draw 'extranet'
    end
    root to: 'home#redirect_to_default_language'
  end
end
