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
                  University::Person::Alumnus.model_name.human(count: 2),
                  admin_university_alumni_path
    primary.item  :subnav_locations,
                  Administration::Location.model_name.human(count: 2),
                  admin_administration_locations_path
    primary.item  :subnav_qualiopi,
                  Administration::Qualiopi.model_name.human(count: 2),
                  admin_administration_qualiopi_criterions_path
  end
end
