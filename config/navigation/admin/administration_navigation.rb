SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::SimpleNavigation::Renderer::Links
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true
  navigation.selected_class = 'active'

  navigation.items do |primary|
    primary.item  :subnav_summary,
                  t('admin.subnav.summary'), 
                  admin_administration_root_path, 
                  highlights_on: lambda { 
                    controller_name == "dashboard" && action_name == "index" 
                  }
    primary.item  :subnav_alumni,
                  t('administration.description.parts.alumnus.title'),
                  admin_administration_alumni_path
    primary.item  :subnav_locations,
                  t('administration.description.parts.location.title'),
                  admin_administration_locations_path
    primary.item  :subnav_qualiopi,
                  t('administration.description.parts.qualiopi.title'),
                  admin_administration_qualiopi_criterions_path,
                  highlights_on: lambda { 
                    controller_name.in?(["indicators", "criterions"])
                  }
  end
end
