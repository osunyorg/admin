Rails.application.routes.draw do
  # Showcase
  constraints host: ENV['OSUNY_SHOWCASE'] do
    get ':feature' => 'showcase/home#feature', 
                      as: :showcase_feature, 
                      constraints: { 
                        feature: /actualites|agenda|portfolio/
                      }
    get ':tag' => 'showcase/home#tag', as: :showcase_tag
    get '/' => 'showcase/home#index'
  end

  # Transparence
  constraints host: ENV['OSUNY_TRANSPARENCY'] do
    get '/' => 'transparency/home#index'
  end

  # Jobs
  authenticated :user, -> user { user.server_admin? } do
    match "/delayed_job" => DelayedJobWeb, :anchor => false, :via => [:get, :post]
  end

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
    resources :users, except: [:new, :create] do
      post 'resend_confirmation_email' => 'users#resend_confirmation_email', on: :member
      patch 'unlock' => 'users#unlock', on: :member
    end
    get 'check' => 'translation#check', as: :check
    post 'check' => 'translation#check'
    post 'translate/:target' => 'translation#translate', as: :translate
    put 'theme' => 'application#set_theme', as: :set_theme
    put 'favorite' => 'users#favorite', as: :favorite
    draw 'admin/administration'
    draw 'admin/communication'
    draw 'admin/education'
    draw 'admin/research'
    draw 'admin/university'
    root to: 'dashboard#index'
  end

  get '/media/:signed_id/:filename_with_transformations' => 'media#show', as: :medium

  draw 'api'
  draw 'server'
  scope module: 'extranet' do
    draw 'extranet'
  end
  root to: 'extranet/home#index'
end
