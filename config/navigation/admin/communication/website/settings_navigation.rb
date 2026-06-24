SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::SimpleNavigation::Renderer::Osuny::FeatureNav
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true

  navigation.items do |primary|
    primary.item  :subnav_settings,
                  t('admin.subnav.settings'),
                  edit_admin_communication_website_path(id: @website.id, website_id: nil),
                  highlights_on: lambda { 
                    controller_name == "websites" && action_name == "edit" 
                  } if can?(:edit, @website)
    primary.item  :subnav_language,
                  current_language,
                  language_admin_communication_website_path(id: @website.id, website_id: nil) if can?(:edit, @website)
    primary.item  :subnav_redirection,
                  t('admin.communication.website.redirects.label'),
                  redirects_admin_communication_website_path(id: @website.id, website_id: nil) if can?(:edit, @website)
    primary.item  :subnav_federation,
                  t('admin.communication.website.federation.label'),
                  federation_admin_communication_website_path(id: @website.id, website_id: nil) if can?(:edit, @website) && current_university.websites.many?
    primary.item  :subnav_technical,
                  t('admin.communication.website.technical.label'),
                  technical_admin_communication_website_path(id: @website.id, website_id: nil) if can?(:edit, @website)
  end
end
