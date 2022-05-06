namespace :communication do
  resources :websites do
    member do
      get :import
      post :import
    end
    resources :pages, controller: 'websites/pages' do
      collection do
        post :reorder
      end
      member do
        get :children
        get :static
      end
    end
    resources :categories, controller: 'websites/categories' do
      collection do
        post :reorder
      end
      member do
        get :children
        get :static
      end
    end
    resources :authors, controller: 'websites/authors', only: [:index, :show]
    resources :posts, controller: 'websites/posts' do
      post :publish, on: :collection
    end
    resources :curations,
              path: 'posts/curations',
              as: :post_curations,
              controller: 'websites/posts/curations',
              only: [:new, :create]
    resources :menus, controller: 'websites/menus' do
      resources :items, controller: 'websites/menu/items', except: :index do
        collection do
          get :kind_switch
          post :reorder
        end
        member do
          get :children
        end
      end
    end
    get   'structure'     => 'websites/structure#edit'
    patch 'structure'     => 'websites/structure#update'
  end
  resources :blocks, controller: 'blocks', except: :index do
    collection do
      post :reorder
    end
  end
  resources :extranets, controller: 'extranets'
  resources :alumni do
    collection do
      resources :imports, only: [:index, :show, :new, :create]
    end
  end
end
