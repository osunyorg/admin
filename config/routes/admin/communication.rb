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
    resources :posts, controller: 'website/posts'
  end
end
