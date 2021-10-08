namespace :communication do
  resources :websites do
    resources :pages, controller: 'website/pages'
    member do
      get :import
      post :import
    end
  end
end
