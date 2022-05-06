namespace :communication do
  get 'unsplash' => 'unsplash#index'
  resources :websites do
    get 'home' => 'website/home#edit'
    patch 'home' => 'website/home#update'
    member do
      get :import
      post :import
    end
    resources :pages, controller: 'website/pages' do
      collection do
        post :reorder
      end
      member do
        get :children
        get :static
      end
    end
    resources :categories, controller: 'website/categories' do
      collection do
        post :reorder
      end
      member do
        get :children
        get :static
      end
    end
    resources :authors, controller: 'website/authors', only: [:index, :show]
    resources :posts, controller: 'website/posts' do
      post :publish, on: :collection
      member do
        get :static
      end
    end
    resources :curations,
              path: 'posts/curations',
              as: :post_curations,
              controller: 'website/posts/curations',
              only: [:new, :create]
    resources :menus, controller: 'website/menus' do
      resources :items, controller: 'website/menu/items', except: :index do
        collection do
          get :kind_switch
          post :reorder
        end
        member do
          get :children
        end
      end
    end
    get   'structure'     => 'website/structure#edit'
    patch 'structure'     => 'website/structure#update'

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
