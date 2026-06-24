constraints host: ENV['OSUNY_SHOWCASE'] do

  namespace :showcase, path: '' do
    resources :instances, only: :index
    resources :websites, only: [:index, :show]

    get ':feature' => 'websites#feature',
                    as: :feature,
                    constraints: {
                      feature: /actualites|agenda|portfolio|jobboard/
                    }
    get ':tag' => 'websites#tag', as: :tag

    root to: 'websites#index'
  end

end
