class Communication::Website::Page::Person < Communication::Website::Page

  def dependencies
    super +
    [website.config_default_languages] +
    website.connected_people
  end

  def explicitly_connected_people
    ids = website.connections.where(indirect_object_type: 'University::Person', direct_source_type: 'Communication::Website::Page::Person', direct_source_id: self.id).pluck(:indirect_object_id)
    University::Person.where(id: ids)
  end

  def self.direct_connection_permitted_about_type
    "University::Person"
  end

  def git_path_relative
    'persons/_index.html'
  end
end
