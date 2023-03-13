namespace :communication do
  scope 'photo-imports' do
    get 'unsplash' => 'photo_imports#unsplash'
    get 'pexels' => 'photo_imports#pexels'
  end
  resources :websites do
    member do
      get :import
      post :import
      get :style
      get :analytics
    end
    resources :pages, controller: 'websites/pages', path: '/:lang/pages' do
      collection do
        post :reorder
      end
      member do
        get :children
        get :static
        get :preview
        get "translate" => "websites/pages#translate", as: :translate
        post :duplicate
      end
    end
    resources :categories, controller: 'websites/categories', path: '/:lang/categories' do
      collection do
        post :reorder
      end
      member do
        get :children
        get :static
      end
    end
    resources :authors, controller: 'websites/authors', path: '/:lang/authors', only: [:index, :show]
    resources :posts, controller: 'websites/posts', path: '/:lang/posts' do
      collection do
        resources :curations, as: :post_curations, controller: 'websites/posts/curations', only: [:new, :create]
        post :publish
      end
      member do
        get :static
        get :preview
      end
    end
    resources :menus, controller: 'websites/menus', path: '/:lang/menus' do
      member do
        get :static
      end
      resources :items, controller: 'websites/menus/items', except: :index do
        collection do
          get :kind_switch
          post :reorder
        end
        member do
          get :children
        end
      end
    end
  end
  resources :blocks, controller: 'blocks', except: [:index] do
    collection do
      post :reorder
    end
    member do
      post :duplicate
    end
  end
  resources :extranets, controller: 'extranets' do
    resources :alumni, only: :index, controller: 'extranets/alumni'
    resources :contacts, only: :index, controller: 'extranets/contacts' do
      collection do
        post :connect
        post :disconnect
      end
    end
    resources :posts, controller: 'extranets/posts' do
      collection do
        resources :categories, controller: 'extranets/posts/categories', as: 'post_categories'
      end
      member do
        get :preview
      end
    end
    # Automatic routes based on feature names
    get 'library' => 'extranets/documents#index', as: :library
    resources :documents, controller: 'extranets/documents' do
      collection do
        resources :categories, controller: 'extranets/documents/categories', as: 'document_categories'
        resources :kinds, controller: 'extranets/documents/kinds', as: 'document_kinds'
      end
    end
    resources :jobs, controller: 'extranets/jobs'
  end
  resources :alumni do
    collection do
      resources :imports, only: [:index, :show, :new, :create]
    end
  end
  root to: 'dashboard#index'
end
