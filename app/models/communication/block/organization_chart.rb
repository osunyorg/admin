class Communication::Block::OrganizationChart < Communication::Block::Template
  def git_dependencies
    dependencies = []
    data['elements'].each do |element|
      element['persons'].each do |person|
        id = person['id']
        next if id.blank?
        person = university.people.find id
        next if person.nil?
        dependencies += [person]
        dependencies += person.active_storage_blobs
      end
    end
    dependencies.uniq
  end
end
