SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::Appstack::SimpleNavigationRenderer
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true
  navigation.selected_class = 'active'
  navigation.items do |primary|
    primary.item :dashboard, t('dashboard'), admin_root_path, { icon: 'tachometer-alt', highlights_on: /admin$/ }

    primary.item :teaching, 'Enseignement', nil, { kind: :header }
    primary.item :teaching, 'Enseignants', nil, { icon: 'user-graduate' }
    primary.item :teaching, 'Ecoles', nil, { icon: 'university' }
    primary.item :education, 'Formations', admin_features_education_programs_path, { icon: 'graduation-cap' }
    primary.item :teaching, 'Ressources éducatives', nil, { icon: 'laptop' }
    primary.item :teaching, 'Feedbacks', nil, { icon: 'comments' }

    primary.item :teaching, 'Recherche', nil, { kind: :header }
    primary.item :teaching, 'Chercheurs', nil, { icon: 'microscope' }
    primary.item :teaching, 'Laboratoires', nil, { icon: 'flask' }
    primary.item :teaching, 'Veille', nil, { icon: 'eye' }
    primary.item :journals, Research::Journal.model_name.human(count: 2), admin_research_journals_path, { icon: 'newspaper' }

    primary.item :teaching, 'Communication', nil, { kind: :header }
    primary.item :websites, 'Sites Web', admin_features_websites_sites_path, { icon: 'sitemap' }
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
