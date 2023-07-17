SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::Appstack::SimpleNavigationRenderer
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true
  navigation.selected_class = 'active'
  navigation.items do |primary|
    primary.item  :dashboard,
                  t('dashboard'),
                  server_root_path,
                  { kind: :header, highlights_on: %r{server$} }
    primary.item  :server,
                  t('server'),
                  nil,
                  { kind: :header }
    primary.item  :universities,
                  University.model_name.human(count: 2),
                  server_universities_path
    primary.item  :websites,
                  Communication::Website.model_name.human(count: 2),
                  server_websites_path
    primary.item  :languages,
                  Language.model_name.human(count: 2),
                  server_languages_path
    primary.item  :blocks,
                  Communication::Block.model_name.human(count: 2),
                  server_blocks_path
    primary.item  :emergency_messages,
                  EmergencyMessage.model_name.human(count: 2),
                  server_emergency_messages_path
  end
end
