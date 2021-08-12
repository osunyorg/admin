Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  draw 'adminserver'
  draw 'admin'

  namespace :features, path: '' do
    Feature.all.each do |feature|
      draw "features/#{feature}"
    end
  end

  namespace :research do
    resources :journals, only: [:index, :show]
  end

  root to: 'home#index'
end
