SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = SimpleNavigation::Renderer::List
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true
  navigation.selected_class = 'active'

  navigation.items do |primary|
    primary.item :communication, t('admin.dashboard'), admin_root_path
    primary.item :websites, Communication::Website.model_name.human(count: 2), admin_communication_websites_path
    primary.item :extranets, Communication::Extranet.model_name.human(count: 2), admin_communication_extranets_path
    primary.item :newsletters, 'Lettres d\'information', nil, html: { class: 'disabled' }
  end
end
