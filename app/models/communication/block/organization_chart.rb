class Communication::Block::OrganizationChart < Communication::Block::Abstract
  def git_dependencies
    dependencies = []
    elements.each do |person|
      id = person['id']
      next if id.blank?
      person = university.people.find id
      next if person.nil?
      dependencies += [person]
      dependencies += person.active_storage_blobs
    end
    dependencies.uniq
  end
end
