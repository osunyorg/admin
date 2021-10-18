SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::Appstack::SimpleNavigationRenderer
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true
  navigation.selected_class = 'active'
  navigation.items do |primary|
    primary.item :dashboard, t('dashboard'), server_root_path, { icon: 'tachometer-alt', highlights_on: %r{server$} }
    primary.item :universities, University.model_name.human(count: 2), server_universities_path, { icon: 'university' } if can?(:read, University)
    primary.item :languages, Language.model_name.human(count: 2), server_languages_path, { icon: 'flag' } if can?(:read, Language)
  end
end
