SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::SimpleNavigation::Renderer::Osuny::FeatureNav
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true

  navigation.items do |primary|
    primary.item  :subnav_settings,
                  t('admin.subnav.settings'),
                  edit_admin_communication_website_path(id: @website.id, website_id: nil) if can?(:edit, @website)
    # TODO L10N : @Arnaud on peut supprimer si qu'un item?
    # Non il faut que je code d'autres menus pour séparer l'édition en plusieurs formulaires plus simples
  end
end
