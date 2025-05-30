SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::SimpleNavigation::Renderer::Osuny::FeatureNav
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true

  navigation.items do |primary|
    primary.item  :feature_nav_organizations,
                  University::Organization.model_name.human(count: 2),
                  admin_university_organizations_path,
                  highlights_on: lambda { 
                    controller_name == "organizations" && action_name == "index" 
                  }
    primary.item  :feature_nav_categories,
                  University::Organization::Category.model_name.human(count: 2),
                  admin_university_organization_categories_path if can?(:read, University::Organization::Category)
  end
end
