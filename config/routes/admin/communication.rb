namespace :communication do
  resources :websites do
    resources :pages, controller: 'website/pages'
  end
end
