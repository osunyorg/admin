namespace :api do
  get 'lheo' => 'lheo#index', defaults: { format: :xml }
  root to: 'dashboard#index'
end
