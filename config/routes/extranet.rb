namespace :university do
  resources :organizations, only: [:index, :show]
end

get 'organizations' => 'university/organizations#index', as: :organizations
get 'organization/:id' => 'university/organizations#show', as: :organization
