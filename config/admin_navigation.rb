SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::Appstack::SimpleNavigationRenderer
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true
  navigation.selected_class = 'active'
  navigation.items do |primary|
    primary.item  :dashboard, t('admin.dashboard'),
                  admin_root_path, 
                  { icon: Icon::DASHBOARD, highlights_on: /admin$/ }

    if can?(:read, University::Person) || can?(:read, University::Organization)
      primary.item :university,
                    University.model_name.human,
                    nil,
                    { kind: :header }
      primary.item :university,
                    University::Person.model_name.human(count: 2),
                    admin_university_people_path,
                    { icon: Icon::UNIVERSITY_PERSON } if can?(:read, University::Person)
      primary.item :university,
                    University::Organization.model_name.human(count: 2),
                    admin_university_organizations_path,
                    { icon: Icon::UNIVERSITY_ORGANIZATION } if can?(:read, University::Organization)
      primary.item :communication_alumni,
                    University::Person::Alumnus.model_name.human(count: 2),
                    admin_university_alumni_path,
                    { icon: Icon::UNIVERSITY_PERSON_ALUMNUS } if can?(:read, University::Person)
    end

    if can?(:read, Education::Program)
      primary.item :education,
                    Education.model_name.human,
                    nil,
                    { kind: :header }
      primary.item :education_teachers,
                    t('education.teachers', count: 2),
                    admin_education_teachers_path,
                    { icon: Icon::EDUCATION_TEACHER } if can?(:read, University::Person)
      primary.item :education_schools,
                    Education::School.model_name.human(count: 2), admin_education_schools_path,
                    { icon: Icon::EDUCATION_SCHOOL } if can?(:read, Education::School)
      primary.item :education_diplomas,
                    Education::Diploma.model_name.human(count: 2), admin_education_diplomas_path,
                    { icon: Icon::EDUCATION_DIPLOMA } if can?(:read, Education::Diploma)
      primary.item :education_programs,
                    Education::Program.model_name.human(count: 2), admin_education_programs_path,
                    { icon: Icon::EDUCATION_PROGRAM } if can?(:read, Education::Program)
      primary.item :education,
                    'Ressources éducatives',
                    nil,
                    { icon: 'laptop' }
      primary.item :education,
                    'Feedbacks',
                    nil,
                    { icon: 'comments' }
    end

    if can?(:read, Research::Publication) || can?(:read, Research::Laboratory)
      primary.item :research,
                    Research.model_name.human,
                    nil,
                    { kind: :header }
      primary.item :research_researchers,
                    t('research.researchers', count: 2),
                    admin_research_researchers_path(journal_id: nil),
                    { icon: Icon::RESEARCH_RESEARCHER } if can?(:read, University::Person)
      primary.item :research_laboratories,
                    Research::Laboratory.model_name.human(count: 2), admin_research_laboratories_path,
                    { icon: Icon::RESEARCH_LABORATORY } if can?(:read, Research::Laboratory)
      primary.item :research_theses,
                    Research::Thesis.model_name.human(count: 2),
                    admin_research_theses_path,
                    { icon: Icon::RESEARCH_THESE } if can?(:read, Research::Thesis)
      primary.item :research_publications,
                    Research::Publication.model_name.human(count: 2),
                    admin_research_publications_path,
                    { icon: Icon::RESEARCH_PUBLICATION } if can?(:read, Research::Publication)
      primary.item :research_watch,
                    'Veille',
                    nil,
                    { icon: 'eye' }
    end

    if can?(:read, Communication::Website)
      primary.item :communication,
                    Communication.model_name.human,
                    nil,
                    { kind: :header }
      primary.item :communication_websites,
                    Communication::Website.model_name.human(count: 2),
                    admin_communication_websites_path,
                    { icon: Icon::COMMUNICATION_WEBSITE } if can?(:read, Communication::Website)
      primary.item :communication_extranets,
                    Communication::Extranet.model_name.human(count: 2), admin_communication_extranets_path,
                    { icon: Icon::COMMUNICATION_EXTRANET } if can?(:read, Communication::Extranet)
      primary.item :communication_newsletters,
                    'Lettres d\'information',
                    nil,
                    { icon: 'envelope' }
    end

    if can?(:read, Administration::Qualiopi::Criterion)
      primary.item :administration,
                    'Administration',
                    nil,
                    { kind: :header }
      primary.item :administration_campus,
                    'Campus',
                    nil,
                    { icon: 'map-marker-alt' }
      primary.item :administration_admissions,
                    'Admissions',
                    nil,
                    { icon: 'door-open' }
      primary.item :administration_internship,
                    'Stages',
                    nil,
                    { icon: 'hands-helping' }
      primary.item :administration_statistics,
                    'Statistiques',
                    nil,
                    { icon: 'chart-bar' }
      primary.item :administration_qualiopi,
                    'Qualité',
                    admin_administration_qualiopi_criterions_path,
                    { icon: 'tasks' } if can?(:read, Administration::Qualiopi::Criterion)
    end

    if can?(:read, User)
      primary.item :administration,
                    'Osuny',
                    nil,
                    { kind: :header }
      primary.item :administration_users,
                    User.model_name.human(count: 2),
                    admin_users_path,
                    { icon: 'user' } if can?(:read, User)
    end
  end
end
