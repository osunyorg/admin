class Communication::Block::Partner < Communication::Block::Abstract
  def build_git_dependencies
    elements.each do |partner|
      blob = find_blob partner, 'logo'
      add_dependency blob unless blob.nil?
      add_partner partner['id']
    end
  end

  protected

  def add_partner(id)
    next if id.blank?
    organization = university.organizations.find id
    next if organization.nil?
    add_dependency organization
    add_dependency organization.active_storage_blobs
  end
end
