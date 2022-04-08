class Communication::Block::Template::OrganizationChart < Communication::Block::Template
  def build_git_dependencies
    persons.each do |person|
      add_dependency person
      add_dependency person.active_storage_blobs
    end
  end

  def persons_with_role
    unless @persons_with_role
      @persons_with_role = []
      elements.each do |element|
        person = block.university.people.find_by id: element['id']
        next if person.nil?
        @persons_with_role << {
          person: person,
          role: element['role']
        }
      end
    end
    @persons_with_role
  end

  def persons
    @persons ||= persons_with_role.map { |hash| hash[:person] }
  end
end
