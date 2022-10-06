Rails.application.routes.draw do
  authenticated :user, -> user { user.server_admin? } do
    match "/delayed_job" => DelayedJobWeb, :anchor => false, :via => [:get, :post]
  end

  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    omniauth_callbacks: 'users/omniauth_callbacks',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    unlocks: 'users/unlocks'
  }

  devise_scope :user do
    post '/users/confirmation/resend' => 'users/confirmations#resend', as: :resend_user_confirmation
    match '/users/auth/saml/setup' => 'users/omniauth_callbacks#saml_setup', via: [:get, :post]
  end

  namespace :admin do
    resources :users do
      post 'resend_confirmation_email' => 'users#resend_confirmation_email', on: :member
      patch 'unlock' => 'users#unlock', on: :member
    end
    draw 'admin/administration'
    draw 'admin/communication'
    draw 'admin/education'
    draw 'admin/research'
    draw 'admin/university'
    root to: 'dashboard#index'
  end


  get '/media/:signed_id/:filename_with_transformations' => 'media#show', as: :medium

  draw 'api'
  draw 'extranet'
  draw 'server'
  # Root is in extranet
end
