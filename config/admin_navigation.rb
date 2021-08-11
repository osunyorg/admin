SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::Appstack::SimpleNavigationRenderer
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true
  navigation.items do |primary|
    primary.item :dashboard, t('dashboard'), admin_root_path, { icon: 'tachometer-alt' }
    primary.item :universities, University.model_name.human(count: 2), admin_universities_path, { icon: 'university' }
    primary.item :users, User.model_name.human(count: 2), admin_users_path, { icon: 'user' }
    primary.item :education, I18n.t('features.education.title'), nil, { icon: 'graduation-cap' } do |secondary|
      secondary.item :dashboard, t('dashboard'), admin_features_education_dashboard_path
      secondary.item :programs, Features::Education::Program.model_name.human(count: 2), admin_features_education_programs_path
      secondary.item :qualiopi, Features::Education::Qualiopi.model_name.human, admin_features_education_qualiopi_criterions_path
    end
    primary.item :settings, 'Paramètres', nil, { icon: 'cog' }
  end
end
