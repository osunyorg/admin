SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::SimpleNavigation::Renderer::Osuny::FeatureNav
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true

  navigation.items do |primary|
    primary.item  :feature_navs_medias,
                  t('communication.description.parts.media.title'), 
                  admin_communication_medias_path
    # primary.item  :feature_nav_categories,
    #               Communication::Media::Category.model_name.human(count: 2),
    #               admin_communication_media_categories_path
  end
end
