namespace :communication do
  get 'unsplash' => 'unsplash#index'
  resources :websites do
    member do
      get :import
      post :import
      get :style
      get :analytics
    end
    resources :pages, controller: 'websites/pages' do
      collection do
        post :reorder
      end
      member do
        get :children
        get :static
        get :preview
        post :duplicate
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
      member do
        get :static
        get :preview
      end
    end
    resources :curations,
              path: 'posts/curations',
              as: :post_curations,
              controller: 'websites/posts/curations',
              only: [:new, :create]
    resources :menus, controller: 'websites/menus' do
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
  resources :extranets, controller: 'extranets'
  resources :alumni do
    collection do
      resources :imports, only: [:index, :show, :new, :create]
    end
  end
end
