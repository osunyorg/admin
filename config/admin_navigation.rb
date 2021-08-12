SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::Appstack::SimpleNavigationRenderer
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true
  navigation.selected_class = 'active'
  navigation.items do |primary|
    primary.item :dashboard, t('dashboard'), admin_root_path, { icon: 'tachometer-alt' }

    primary.item :teaching, 'Enseignement', nil, { kind: :header }
    primary.item :education, 'Formations', nil, { icon: 'graduation-cap' } do |secondary|
      secondary.item :dashboard, t('dashboard'), admin_features_education_dashboard_path
      secondary.item :programs, Features::Education::Program.model_name.human(count: 2), admin_features_education_programs_path
      secondary.item :qualiopi, Features::Education::Qualiopi.model_name.human, admin_features_education_qualiopi_criterions_path
    end
    primary.item :teaching, 'Ecoles', nil, { icon: 'university' }
    primary.item :teaching, 'Enseignants', nil, { icon: 'user-graduate' }
    primary.item :teaching, 'Feedbacks', nil, { icon: 'comments' }
    primary.item :teaching, 'Ressources éducatives', nil, { icon: 'laptop' }

    primary.item :teaching, 'Recherche', nil, { kind: :header }
    primary.item :teaching, 'Laboratoires', nil, { icon: 'flask' }
    primary.item :teaching, 'Chercheurs', nil, { icon: 'microscope' }
    primary.item :teaching, 'Journaux', nil, { icon: 'newspaper' }
    primary.item :teaching, 'Veille', nil, { icon: 'eye' }

    primary.item :teaching, 'Communication', nil, { kind: :header }
    primary.item :websites, Features::Websites.model_name.human, nil, { icon: 'sitemap' } do |secondary|
      secondary.item :dashboard, t('dashboard'), admin_features_websites_dashboard_path
      secondary.item :sites, Features::Websites::Site.model_name.human(count: 2), admin_features_websites_sites_path
    end
    primary.item :teaching, 'Lettres d\'information', nil, { icon: 'envelope' }
    primary.item :teaching, 'Alumni', nil, { icon: 'users' }

    primary.item :teaching, 'Administration', nil, { kind: :header }
    primary.item :users, User.model_name.human(count: 2), admin_users_path, { icon: 'user' }
    primary.item :settings, 'Campus', nil, { icon: 'map-marker-alt' }
    primary.item :settings, 'Admissions', nil, { icon: 'door-open' }
    primary.item :settings, 'Statistiques', nil, { icon: 'cog' }
    primary.item :settings, 'Qualité', admin_features_education_qualiopi_criterions_path, { icon: 'tasks' }
  end
end
