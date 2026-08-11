SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::SimpleNavigation::Renderer::Osuny::FeatureNav
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true

  navigation.items do |primary|
    primary.item  :subnav_settings,
                  t('admin.subnav.settings'),
                  edit_admin_communication_extranet_path(id: @extranet.id, extranet_id: nil),
                  highlights_on: lambda { 
                    controller_name == "extranets" && action_name == "edit" 
                  } if can?(:edit, @extranet)
    primary.item  :subnav_sso,
                  t('admin.communication.extranet.sso.label'),
                  sso_admin_communication_extranet_path(id: @extranet.id, extranet_id: nil) if can?(:create, @extranet)
  end
end
