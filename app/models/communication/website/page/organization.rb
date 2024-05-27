class Communication::Website::Page::Organization < Communication::Website::Page

  # TODO: Scope .where(language_id: language_id) when organizations are translatable
  def dependencies
    super +
    [website.config_default_languages] +
    website.connected_organizations.where(language_id: language_id)
  end

  def explicitly_connected_organizations
    ids = website.connections.where(indirect_object_type: 'University::Organization', direct_source_type: 'Communication::Website::Page::Organization', direct_source_id: self.id).pluck(:indirect_object_id)
    University::Organization.where(id: ids)
  end

  def self.direct_connection_permitted_about_type
    "University::Organization"
  end

  def git_path_relative
    'organizations/_index.html'
  end
end
