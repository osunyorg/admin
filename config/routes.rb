Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  draw 'admin'
  draw 'server'

  draw 'education'
  draw 'research'
  draw 'communication'
  draw 'administration'

  root to: 'communication/website/pages#index'
end
