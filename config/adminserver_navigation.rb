SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::Appstack::SimpleNavigationRenderer
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true
  navigation.selected_class = 'active'
  navigation.items do |primary|
    primary.item :dashboard, t('dashboard'), adminserver_root_path, { icon: 'tachometer-alt', highlights_on: %r{adminserver$} }
    primary.item :universities, University.model_name.human(count: 2), adminserver_universities_path, { icon: 'university' }
  end
end
