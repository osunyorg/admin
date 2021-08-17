namespace :admin do
  resources :users
  draw 'admin/education'
  draw 'admin/research'
  draw 'admin/communication'
  draw 'admin/administration'
  root to: 'dashboard#index'
end
