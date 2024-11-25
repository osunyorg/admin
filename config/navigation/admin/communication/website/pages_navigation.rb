SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::SimpleNavigation::Renderer::Osuny::FeatureNav
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true

  navigation.items do |primary|
    primary.item  :feature_nav_pages,
                  t('admin.communication.website.subnav.structure'),
                  admin_communication_website_pages_path(website_id: @website.id),
                  highlights_on: lambda {
                    controller_name == "pages" && action_name.in?(["index", "index_list"])
                  }
    primary.item  :feature_nav_categories,
                  Communication::Website::Page::Category.model_name.human(count: 2),
                  admin_communication_website_page_categories_path(website_id: @website.id)
  end
end
