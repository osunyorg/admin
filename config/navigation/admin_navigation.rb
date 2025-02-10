SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::Osuny::SimpleNavigationRenderer
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true

  navigation.items do |primary|
    primary.item :communication, t('communication.description.title'), admin_communication_root_path, { image: 'admin/communication-thumb.jpg' } do |secondary|
      secondary.item :communication_websites, Communication::Website.model_name.human(count: 2), admin_communication_websites_path
      secondary.item :communication_extranets, Communication::Extranet.model_name.human(count: 2), admin_communication_extranets_path
      secondary.item :communication_media, t('communication.description.parts.media.title'), admin_communication_medias_path
      secondary.item :communication_newsletters, 'Lettres d\'information', nil
    end
    primary.item :directory, t('university.description.title'), admin_university_root_path, { image: 'admin/university-thumb.jpg' } do |secondary|
      secondary.item :directory_persons, University::Person.model_name.human(count: 2), admin_university_people_path
      secondary.item :directory_organizations, University::Organization.model_name.human(count: 2), admin_university_organizations_path
      secondary.item :directory_users, User.model_name.human(count: 2), admin_users_path
    end
  end
end
