SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::SimpleNavigation::Renderer::Links
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true
  navigation.selected_class = 'active'

  navigation.items do |primary|
    primary.item  :subnav_summary,
                  t('admin.subnav.summary'), 
                  admin_university_root_path, 
                  highlights_on: lambda { 
                    controller_name == "dashboard" && action_name == "index" 
                  }
    primary.item  :subnav_people,
                  University::Person.model_name.human(count: 2),
                  admin_university_people_path if can?(:read, University::Person)
    primary.item  :subnav_organizations,
                  University::Organization.model_name.human(count: 2),
                  admin_university_organizations_path if can?(:read, University::Organization)
    primary.item  :subnav_users,
                  User.model_name.human(count: 2),
                  admin_users_path if can?(:read, User)
  end
end
