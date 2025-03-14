namespace :university, path: :directory do
  # Resources must come after namespaces, otherwise there is a confusion with ids
  namespace :organizations do
    resources :imports, only: [:index, :show, :new, :create]
  end
  resources :apps do
    post :regenerate_token, on: :member
  end
  namespace :people do
    resources :imports, only: [:index, :show, :new, :create]
    namespace :experiences do
      resources :imports, only: [:index, :show, :new, :create]
    end
  end
  resources :people do
    collection do
      get :search, defaults: { format: 'json' }
      resources :categories, controller: 'people/categories', as: 'person_categories' do
        collection do
          post :reorder
        end  
        member do
          get :children
          get :static
        end
      end
    end
    member do
      get :static
      get 'administrator/static' => 'people/administrators#static', as: 'static_administrator' 
      get 'author/static' => 'people/authors#static', as: 'static_author' 
      get 'experiences' => 'people/experiences#edit'
      patch 'experiences' => 'people/experiences#update'
    end
  end

  resources :organizations do
    collection do
      get :search, defaults: { format: 'json' }
      resources :categories, controller: 'organizations/categories', as: 'organization_categories' do
        collection do
          post :reorder
        end  
        member do
          get :children
          get :static
        end
      end
    end
    member do
      get :static
    end
  end
  root to: 'dashboard#index'
end
