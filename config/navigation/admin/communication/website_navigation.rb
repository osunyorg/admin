SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::SimpleNavigation::Renderer::Links
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true
  navigation.selected_class = 'active'

  navigation.items do |primary|
    primary.item  :subnav_summary,
                  t('admin.subnav.summary'), 
                  admin_communication_website_path(id: @website, website_id: nil),
                  highlights_on: lambda { 
                    controller_name == "websites" && action_name == "show" 
                  } if can?(:read, @website)
    primary.item  :subnav_posts,
                  @website.feature_posts_name(current_language),
                  admin_communication_website_posts_path(website_id: @website.id),
                  highlights_on: lambda { 
                    admin_communication_website_posts_path(website_id: @website.id).in?(request.path) ||
                    admin_communication_website_post_categories_path(website_id: @website.id).in?(request.path) ||
                    admin_communication_website_post_authors_path(website_id: @website.id).in?(request.path)
                  } if @website.feature_posts
    primary.item  :subnav_agenda,
                  @website.feature_agenda_name(current_language),
                  admin_communication_website_agenda_events_path(website_id: @website.id),
                  highlights_on: lambda { 
                    admin_communication_website_agenda_root_path(website_id: @website.id).in?(request.path) 
                  } if @website.feature_agenda
    primary.item  :subnav_portfolio,
                  @website.feature_portfolio_name(current_language),
                  admin_communication_website_portfolio_projects_path(website_id: @website.id),
                  highlights_on: lambda { 
                    admin_communication_website_portfolio_root_path(website_id: @website.id).in?(request.path) 
                  } if @website.feature_portfolio
    primary.item  :subnav_pages,
                  t('admin.communication.website.subnav.structure'),
                  admin_communication_website_pages_path(website_id: @website.id) if can?(:read, Communication::Website::Page)
    primary.item  :subnav_menus,
                  Communication::Website::Menu.model_name.human(count: 2),
                  admin_communication_website_menus_path(website_id: @website.id) if can?(:read, Communication::Website::Menu)
    primary.item  :subnav_analytics,
                  t('communication.website.analytics'),
                  analytics_admin_communication_website_path(id: @website.id, website_id: nil) if @website.plausible_url.present?
    primary.item  :subnav_settings,
                  t('admin.subnav.settings'),
                  edit_admin_communication_website_path(id: @website.id, website_id: nil),
                  highlights_on: lambda { 
                    controller_name == 'websites' && action_name == 'edit' ||
                    controller_name == 'localizations'
                  } if can?(:edit, @website)
  end
end
