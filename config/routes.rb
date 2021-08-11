Rails.application.routes.draw do
  devise_for :users

  draw 'adminserver'
  draw 'admin'

  namespace :features, path: '' do
    Feature.all.each do |feature|
      draw "features/#{feature}"
    end
  end

  root to: 'home#index'
end
