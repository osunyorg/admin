namespace :communication do
  resources :websites do
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
    resources :authors, controller: 'website/authors'
    resources :posts, controller: 'website/posts'
    resources :menus, controller: 'website/menus' do
      resources :items, controller: 'website/menu/items', except: :index do
        collection do
          post :reorder
        end
        member do
          get :children
        end
      end
    end
  end
end
