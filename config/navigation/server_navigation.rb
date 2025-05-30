SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = SimpleNavigation::Renderer::List
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true
  navigation.selected_class = 'active'
  navigation.items do |primary|
    primary.item  :server, t('menu.server_admin'), nil, html: { class: 'section' }
    primary.item  :universities,
                  University.model_name.human(count: 2),
                  server_universities_path
    primary.item  :languages,
                  Language.model_name.human(count: 2),
                  server_languages_path
    primary.item  :emergency_messages,
                  EmergencyMessage.model_name.human(count: 2),
                  server_emergency_messages_path
    primary.item  :background_jobs,
                  'Jobs',
                  server_background_jobs_path
    primary.item  :communication, Communication.model_name.human, nil, html: { class: 'section' }
    primary.item  :websites,
                  Communication::Website.model_name.human(count: 2),
                  server_websites_path
    primary.item  :blocks,
                  Communication::Block.model_name.human(count: 2),
                  server_blocks_path
    primary.item  :layouts,
                  Communication::Website::GitFile::Layout.model_name.human(count: 2),
                  server_overrides_path
    primary.item  :tags,
                  Communication::Website::Showcase::Tag.model_name.human(count: 2),
                  server_tags_path
  end
end
