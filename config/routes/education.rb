namespace :education do
  resources :programs, only: [:index, :show]
end
