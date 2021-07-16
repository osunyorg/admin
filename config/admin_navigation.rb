SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::Appstack::SimpleNavigationRenderer
  navigation.auto_highlight = true
  # navigation.highlight_on_subpath = true
  navigation.items do |primary|
    primary.item :dashboard, 'Tableau de bord', admin_root_path, { icon: 'tachometer-alt' }
    primary.item :universities, University.model_name.human(count: 2), admin_universities_path, { icon: 'university' }
    primary.item :users, User.model_name.human(count: 2), admin_users_path, { icon: 'user' }
    primary.item :programs, Program.model_name.human(count: 2), admin_programs_path, { icon: 'graduation-cap' }
    primary.item :qualiopi, 'Qualiopi', admin_qualiopi_root_path, { icon: 'check-circle' }
    primary.item :settings, 'Paramètres', '', { icon: 'cog' }
  end
end
