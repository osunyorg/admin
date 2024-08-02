SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = SimpleNavigation::Renderer::List
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true
  navigation.selected_class = 'active'

  navigation.items do |primary|
    primary.item  :persons,
                  University::Person.model_name.human(count: 2),
                  admin_university_people_path
    primary.item  :organizations,
                  University::Organization.model_name.human(count: 2),
                  admin_university_organizations_path
    primary.item  :users,
                  User.model_name.human(count: 2),
                  admin_users_path
  end
end
