SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::Osuny::SimpleNavigationRenderer
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true

  def load_from_parts class_name, menu
    class_name.parts.each do |part|
      class_name = part.first
      identifier = class_name.to_s.to_sym
      label = class_name.model_name.human(count: 2)
      path = send part.last, lang: current_language.iso_code
      menu.item identifier, label, path if can?(:read, class_name)
    end
  end

  navigation.items do |primary|
    if feature_education?
      primary.item :education, Education.model_name.human, admin_education_root_path, { image: 'admin/education-thumb.jpg' } do |secondary|
        load_from_parts Education, secondary
        secondary.item :education_rel, 'Ressources éducatives', nil
        secondary.item :education_feedbacks, 'Feedbacks', nil
      end
    end

    if feature_research?
      primary.item :research, Research.model_name.human, admin_research_root_path, { image: 'admin/research-thumb.jpg' } do |secondary|
        load_from_parts Research, secondary
        secondary.item :research_watch, 'Veille', nil
      end
    end

    if feature_communication?
      primary.item :communication, Communication.model_name.human, admin_communication_root_path, { image: 'admin/communication-thumb.jpg' } do |secondary|
        load_from_parts Communication, secondary
        secondary.item :communication_newsletters, 'Lettres d\'information', nil
      end
    end

    if feature_administration?
      primary.item :administration, Administration.model_name.human, admin_administration_root_path, { image: 'admin/administration-thumb.jpg' } do |secondary|
        load_from_parts Administration, secondary
        secondary.item :administration_admissions, 'Admissions', nil
        secondary.item :administration_internship, 'Stages', nil
        secondary.item :administration_statistics, 'Statistiques', nil
      end
    end

    primary.item :directory, t('admin.directory'), admin_university_root_path, { image: 'admin/university-thumb.jpg' } do |secondary|
      secondary.item :directory_persons, University::Person.model_name.human(count: 2), admin_university_people_path
      secondary.item :directory_organizations, University::Organization.model_name.human(count: 2), admin_university_organizations_path
      secondary.item :directory_users, User.model_name.human(count: 2), admin_users_path
    end
  end
end
