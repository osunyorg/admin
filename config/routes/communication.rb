namespace :communication do
  namespace :website do
    resources :pages, only: [:index, :show]
  end
end
