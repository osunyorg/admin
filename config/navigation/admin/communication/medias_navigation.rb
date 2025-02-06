SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::SimpleNavigation::Renderer::Osuny::FeatureNav
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true

  navigation.items do |primary|
    primary.item  :feature_nav_medias,
                  t('communication.description.parts.media.title'),
                  admin_communication_medias_path,
                  highlights_on: lambda {
                    controller_name == "medias" && action_name == "index"
                  }
    primary.item  :feature_nav_collections,
                  Communication::Media::Collection.model_name.human(count: 2),
                  admin_communication_media_collections_path if can?(:read, Communication::Media::Collection)
    primary.item  :feature_nav_categories,
                  Communication::Media::Category.model_name.human(count: 2),
                  admin_communication_media_categories_path if can?(:read, Communication::Media::Category)
  end
end
