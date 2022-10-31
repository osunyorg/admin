namespace :server do
  resources :universities, :languages, :websites
  get 'blocks' => 'blocks#index', as: :blocks
  get 'blocks/:id' => 'blocks#show', as: :block
  post 'blocks/:id' => 'blocks#resave', as: :resave_block
  root to: 'dashboard#index'
end
