SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::Osuny::SimpleNavigationRenderer
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true
  navigation.selected_class = 'active'

  def load_realm(realm, primary)
    realm.parts.each do |part|
      name = part.first
      identifier = name.to_s.to_sym
      key = "#{realm.to_s.downcase}.description.parts.#{name.to_s.demodulize.downcase}.title"
      label = I18n.t(key)
      path = send part.last, lang: current_language.iso_code
      primary.item identifier, label, path if can?(:read, name)
    end
  end

  navigation.items do |primary|
    if feature_education?
      primary.item :education, Education.model_name.human, admin_education_root_path, { kind: :header, image: 'admin/education-thumb.jpg' }
      load_realm Education, primary
      primary.item :education, 'Ressources éducatives', nil, html: { class: 'disabled' }
      primary.item :education, 'Feedbacks', nil, html: { class: 'disabled' }
    end

    if feature_research?
      primary.item :research, Research.model_name.human, admin_research_root_path, { kind: :header, image: 'admin/research-thumb.jpg' }
      load_realm Research, primary
      primary.item :research_watch, 'Veille', nil, html: { class: 'disabled' }
    end

    if feature_communication?
      primary.item :communication, Communication.model_name.human, admin_communication_root_path, { kind: :header, image: 'admin/communication-thumb.jpg' }
      load_realm Communication, primary
      primary.item :communication_newsletters, 'Lettres d\'information', nil, html: { class: 'disabled' }
    end

    if feature_administration?
      primary.item :administration, Administration.model_name.human, admin_administration_root_path, { kind: :header, image: 'admin/administration-thumb.jpg' }
      load_realm Administration, primary
      primary.item :administration_admissions, 'Admissions', nil, html: { class: 'disabled' }
      primary.item :administration_internship, 'Stages', nil, html: { class: 'disabled' }
      primary.item :administration_statistics, 'Statistiques', nil, html: { class: 'disabled' }
    end
  end
end
