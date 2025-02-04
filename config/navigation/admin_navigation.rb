SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::Osuny::SimpleNavigationRenderer
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true

  navigation.items do |primary|
    primary.item :websites, Communication::Website.model_name.human(count: 2), admin_communication_websites_path
    primary.item :extranets, Communication::Extranet.model_name.human(count: 2), admin_communication_extranets_path
    primary.item :media, t('communication.description.parts.media.title'), admin_communication_medias_path
    primary.item :newsletters, 'Lettres d\'information', nil
    primary.item :persons, University::Person.model_name.human(count: 2), admin_university_people_path
    primary.item :organizations, University::Organization.model_name.human(count: 2), admin_university_organizations_path
    primary.item :users, User.model_name.human(count: 2), admin_users_path
  end
end
