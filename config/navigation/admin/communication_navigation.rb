SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::SimpleNavigation::Renderer::Links
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true
  navigation.selected_class = 'active'

  navigation.items do |primary|
    primary.item  :subnav_summary,
                  t('admin.subnav.summary'), 
                  admin_communication_root_path, 
                  highlights_on: lambda { 
                    controller_name == "dashboard" && action_name == "index" 
                  }
    primary.item  :subnav_authors,
                  University::Person::Localization::Author.model_name.human(count: 2),
                  admin_communication_authors_path
    primary.item  :subnav_websites,
                  Communication::Website.model_name.human(count: 2),
                  admin_communication_websites_path
    primary.item  :subnav_extranets,
                  Communication::Extranet.model_name.human(count: 2),
                  admin_communication_extranets_path
    primary.item  :subnav_medias,
                  Communication::Media.model_name.human(count: 2),
                  admin_communication_medias_path
  end
end
