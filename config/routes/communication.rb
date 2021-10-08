namespace :communication do
  resources :websites do
    member do
      get :import
      post :import
    end
    resources :pages, controller: 'website/pages'
    resources :posts, controller: 'website/posts'
  end
end
