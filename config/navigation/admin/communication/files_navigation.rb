SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::SimpleNavigation::Renderer::Osuny::FeatureNav
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true

  navigation.items do |primary|
    primary.item  :feature_nav_files,
                  t('communication.description.parts.file.title'),
                  admin_communication_files_path,
                  highlights_on: lambda {
                    controller_name == "files" && action_name == "index"
                  }
    primary.item  :feature_nav_categories,
                  Communication::File::Category.model_name.human(count: 2),
                  admin_communication_file_categories_path if can?(:read, Communication::File::Category)
  end
end
