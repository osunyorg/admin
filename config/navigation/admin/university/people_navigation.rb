SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::SimpleNavigation::Renderer::Osuny::FeatureNav
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true

  navigation.items do |primary|
    primary.item  :feature_nav_people,
                  University::Person.model_name.human(count: 2),
                  admin_university_people_path,
                  highlights_on: lambda { 
                    controller_name == "people" && action_name == "index" 
                  }
    primary.item  :feature_nav_categories,
                  University::Person::Category.model_name.human(count: 2),
                  admin_university_person_categories_path if can?(:read, University::Person::Category)
  end
end
