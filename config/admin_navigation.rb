SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::Appstack::SimpleNavigationRenderer
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true
  navigation.selected_class = 'active'
  navigation.items do |primary|
    primary.item :dashboard, t('dashboard'), admin_root_path, { icon: 'tachometer-alt', highlights_on: /admin$/ }

    if can?(:read, Education::Program)
      primary.item :education, Education.model_name.human, nil, { kind: :header }
      primary.item :education, 'Enseignants', nil, { icon: 'user-graduate' }
      primary.item :education, 'Ecoles', nil, { icon: 'university' }
      primary.item :education_programs, Education::Program.model_name.human(count: 2), admin_education_programs_path, { icon: 'graduation-cap' } if can?(:read, Education::Program)
      primary.item :education, 'Ressources éducatives', nil, { icon: 'laptop' }
      primary.item :education, 'Feedbacks', nil, { icon: 'comments' }
    end

    if can?(:read, Research::Researcher) || can?(:read, Research::Journal)
      primary.item :research, Research.model_name.human, nil, { kind: :header }
      primary.item :research_researchers, Research::Researcher.model_name.human(count: 2), admin_research_researchers_path(journal_id: nil), { icon: 'microscope' } if can?(:read, Research::Researcher)
      primary.item :research, 'Laboratoires', nil, { icon: 'flask' }
      primary.item :research, 'Veille', nil, { icon: 'eye' }
      primary.item :research_journals, Research::Journal.model_name.human(count: 2), admin_research_journals_path, { icon: 'newspaper' } if can?(:read, Research::Journal)
    end

    if can?(:read, Communication::Website)
      primary.item :communication, 'Communication', nil, { kind: :header }
      primary.item :communication_websites, 'Sites Web', admin_communication_websites_path, { icon: 'sitemap' } if can?(:read, Communication::Website)
      primary.item :communication, 'Lettres d\'information', nil, { icon: 'envelope' }
      primary.item :communication, 'Alumni', nil, { icon: 'users' }
    end

    if can?(:read, User) || can?(:read, Administration::Qualiopi::Criterion)
      primary.item :administration, 'Administration', nil, { kind: :header }
      primary.item :administration_users, User.model_name.human(count: 2), admin_users_path, { icon: 'user' } if can?(:read, User)
      primary.item :administration, 'Campus', nil, { icon: 'map-marker-alt' }
      primary.item :administration, 'Admissions', nil, { icon: 'door-open' }
      primary.item :administration, 'Statistiques', nil, { icon: 'cog' }
      primary.item :administration_qualiopi, 'Qualité', admin_administration_qualiopi_criterions_path, { icon: 'tasks' } if can?(:read, Administration::Qualiopi::Criterion)
    end
  end
end
