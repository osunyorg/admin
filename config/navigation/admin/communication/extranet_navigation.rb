SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::SimpleNavigation::Renderer::Links
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true
  navigation.selected_class = 'active'

  navigation.items do |primary|
    primary.item  :subnav_summary,
                  t('admin.subnav.summary'), 
                  admin_communication_extranet_path(id: @extranet, extranet_id: nil),
                  highlights_on: lambda { 
                    controller_name == "extranets" && action_name == "show" 
                  } if can?(:read, @extranet)
    Communication::Extranet::FEATURES.each do |feature|
      next unless @extranet.has_feature? feature
      property = "feature_#{feature}"
      primary.item  property.to_sym,
                    Communication::Extranet.human_attribute_name(property),
                    send("admin_communication_extranet_#{feature}_path")
    end
    primary.item  :subnav_settings,
                  t('admin.subnav.settings'),
                  edit_admin_communication_extranet_path(id: @extranet.id, extranet_id: nil) if can?(:edit, @extranet)
  end
end
