namespace :server do
  resources :universities, :languages
  get 'blocks' => 'blocks#index', as: :blocks
  get 'blocks/:id' => 'blocks#show', as: :block
  root to: 'dashboard#index'
end
