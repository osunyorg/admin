SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::Appstack::SimpleNavigationRenderer
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true
  navigation.selected_class = 'active'
  navigation.items do |primary|
    primary.item :dashboard, t('admin.dashboard'), admin_root_path, { icon: 'tachometer-alt', highlights_on: /admin$/ }

    if can?(:read, User) || can?(:read, University::Person) || can?(:read, University::Organization)
      primary.item :university, University.model_name.human, nil, { kind: :header }
      primary.item :university, University::Person.model_name.human(count: 2), admin_university_people_path, { icon: 'users-cog' }
      primary.item :university, University::Organization.model_name.human(count: 2), admin_university_organizations_path, { icon: 'building' }
      primary.item :communication_alumni, University::Person::Alumnus.model_name.human(count: 2), admin_university_person_alumni_path, { icon: 'users' }
    end

    if can?(:read, Education::Program)
      primary.item :education, Education.model_name.human, nil, { kind: :header }
      primary.item :education, t('education.teachers', count: 2), admin_education_teachers_path, { icon: 'user-graduate' } if can?(:read, University::Person)
      primary.item :education, Education::School.model_name.human(count: 2), admin_education_schools_path, { icon: 'university' } if can?(:read, Education::School)
      primary.item :education_programs, Education::Program.model_name.human(count: 2), admin_education_programs_path, { icon: 'graduation-cap' } if can?(:read, Education::Program)
      primary.item :education, 'Ressources éducatives', nil, { icon: 'laptop' }
      primary.item :education, 'Feedbacks', nil, { icon: 'comments' }
    end

    if can?(:read, Research::Journal) || can?(:read, Research::Laboratory)
      primary.item :research, Research.model_name.human, nil, { kind: :header }
      primary.item :research_researchers, t('research.researchers', count: 2), admin_research_researchers_path(journal_id: nil), { icon: 'microscope' } if can?(:read, University::Person)
      primary.item :research_laboratories, Research::Laboratory.model_name.human(count: 2), admin_research_laboratories_path, { icon: 'flask' } if can?(:read, Research::Laboratory)
      primary.item :research_theses, Research::Thesis.model_name.human(count: 2), admin_research_theses_path, { icon: 'scroll' } if can?(:read, Research::Thesis)
      primary.item :research_journals, Research::Journal.model_name.human(count: 2), admin_research_journals_path, { icon: 'newspaper' } if can?(:read, Research::Journal)
      primary.item :research_watch, 'Veille', nil, { icon: 'eye' }
    end

    if can?(:read, Communication::Website)
      primary.item :communication, Communication.model_name.human, nil, { kind: :header }
      primary.item :communication_websites, Communication::Website.model_name.human(count: 2), admin_communication_websites_path, { icon: 'sitemap' } if can?(:read, Communication::Website)
      primary.item :communication_extranets, Communication::Extranet.model_name.human(count: 2), admin_communication_extranets_path, { icon: 'project-diagram' }
      primary.item :communication_newsletters, 'Lettres d\'information', nil, { icon: 'envelope' }
    end

    if can?(:read, Administration::Qualiopi::Criterion)
      primary.item :administration, 'Administration', nil, { kind: :header }
      primary.item :administration_campus, 'Campus', nil, { icon: 'map-marker-alt' }
      primary.item :administration_admissions, 'Admissions', nil, { icon: 'door-open' }
      primary.item :administration_internship, 'Stages', nil, { icon: 'hands-helping' }
      primary.item :administration_statistics, 'Statistiques', nil, { icon: 'chart-bar' }
      primary.item :administration_qualiopi, 'Qualité', admin_administration_qualiopi_criterions_path, { icon: 'tasks' } if can?(:read, Administration::Qualiopi::Criterion)
    end

    if can?(:read, User)
      primary.item :administration, 'Osuny', nil, { kind: :header }
      primary.item :administration_users, User.model_name.human(count: 2), admin_users_path, { icon: 'user' } if can?(:read, User)
    end
  end
end
