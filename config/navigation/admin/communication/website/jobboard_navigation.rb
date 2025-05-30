SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::SimpleNavigation::Renderer::Osuny::FeatureNav
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true

  navigation.items do |primary|
    primary.item  :feature_nav_jobs,
                  @website.feature_jobboard_name(current_language),
                  admin_communication_website_jobboard_jobs_path(website_id: @website.id)
    primary.item  :feature_nav_categories,
                  Communication::Website::Jobboard::Category.model_name.human(count: 2),
                  admin_communication_website_jobboard_categories_path(website_id: @website.id)
  end
end
