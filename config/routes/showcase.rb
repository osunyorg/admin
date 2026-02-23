constraints host: ENV['OSUNY_SHOWCASE'] do
  get '/index' => 'showcase/websites#index'
  get ':feature' => 'showcase/websites#feature',
                    as: :showcase_feature,
                    constraints: {
                      feature: /actualites|agenda|portfolio|jobboard/
                    }
  get ':tag' => 'showcase/websites#tag', as: :showcase_tag
  get '/' => 'showcase/websites#index'
  get 'websites/:id' => 'showcase/websites#show', as: :showcase_website
end
