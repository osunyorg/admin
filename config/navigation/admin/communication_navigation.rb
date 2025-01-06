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
                  t('communication.description.parts.author.title'),
                  admin_communication_authors_path
    primary.item  :subnav_websites,
                  t('communication.description.parts.website.title'),
                  admin_communication_websites_path
    primary.item  :subnav_extranets,
                  t('communication.description.parts.extranet.title'),
                  admin_communication_extranets_path
    primary.item  :subnav_medias,
                  t('communication.description.parts.media.title'),
                  admin_communication_medias_path
  end
end
