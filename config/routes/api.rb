namespace :api do
  get 'lheo' => 'lheo#index', defaults: { format: :xml }
  root to: 'application#index'
end
