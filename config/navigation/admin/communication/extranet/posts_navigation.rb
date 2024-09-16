SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::SimpleNavigation::Renderer::Osuny::FeatureNav
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true

  navigation.items do |primary|
    primary.item  :feature_nav_posts,
                  Communication::Extranet::Post.model_name.human(count: 2),
                  admin_communication_extranet_posts_path(extranet_id: @extranet.id),
                  highlights_on: lambda { 
                    controller_name == "posts" && action_name == "index" 
                  }
    primary.item  :feature_nav_categories,
                  Communication::Extranet::Post::Category.model_name.human(count: 2),
                  admin_communication_extranet_post_categories_path(extranet_id: @extranet.id)
  end
end
