SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::SimpleNavigation::Renderer::Osuny::FeatureNav
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true

  navigation.items do |primary|
    primary.item  :feature_nav_programs,
                  Education::Program.model_name.human(count: 2),
                  admin_education_programs_path,
                  highlights_on: lambda { 
                    controller_name == "programs" && action_name == "index" 
                  }
    primary.item  :feature_nav_categories,
                  Education::Program::Category.model_name.human(count: 2),
                  admin_education_program_categories_path
  end
end
