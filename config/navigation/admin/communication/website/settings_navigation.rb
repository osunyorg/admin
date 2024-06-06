SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::SimpleNavigation::Renderer::Osuny::FeatureNav
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true

  navigation.items do |primary|
    primary.item  :subnav_settings,
                  t('admin.subnav.settings'),
                  edit_admin_communication_website_path(id: @website.id, website_id: nil) if can?(:edit, @website)
    primary.item  :subnav_localizations,
                  t('admin.communication.website.localizations.title'),
                  admin_communication_website_localization_path(website_id: @website.id) if can?(:read, Communication::Website::Localization) && @website.languages.many?
  end
end
