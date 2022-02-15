namespace :communication do
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
      end
    end
    resources :categories, controller: 'website/categories' do
      collection do
        post :reorder
      end
      member do
        get :children
      end
    end
    resources :authors, controller: 'website/authors', only: [:index, :show]
    resources :posts, controller: 'website/posts'
    resources :curations, path: 'posts/curations', as: :post_curations, controller: 'website/posts/curations', only: [:new, :create]
    resources :blocks, controller: 'website/blocks', except: [:index, :show] do
      collection do
        post :reorder
      end
    end
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
    get 'structure' => 'website/structure#edit'
    patch 'structure' => 'website/structure#update'
  end
end
