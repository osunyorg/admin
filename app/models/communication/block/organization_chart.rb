class Communication::Block::OrganizationChart < Communication::Block::Abstract
  def build_git_dependencies
    elements.each do |person|
      id = person['id']
      next if id.blank?
      person = university.people.find id
      next if person.nil?
      add_dependency person
      add_dependency person.active_storage_blobs
    end
  end
end
