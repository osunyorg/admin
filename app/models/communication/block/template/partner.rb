class Communication::Block::Template::Partner < Communication::Block::Template::Base
  def build_git_dependencies
    add_dependency active_storage_blobs
    add_dependency organizations
    organizations.each do |organization|
      add_dependency organization.active_storage_blobs
    end
  end

  def partners
    @partners ||= elements.map { |element|
      partner(element)
    }.compact
  end

  def active_storage_blobs
    @active_storage_blobs ||= partners.map { |partner|
      partner.blob
    }.compact
  end

  protected

  def organizations
    @organizations ||= partners.map { |partner|
      partner.organization
    }.compact
  end

  def partner(element)
    # Init to have easy tests in the views and dependencies
    element['organization'] = nil
    element['blob'] = nil
    if element['id']
      organization = university.organizations.find_by id: element['id']
      if organization
        element['organization'] = organization
        element['name'] = organization.to_s
        element['url'] = organization.url
        element['blob'] = organization.logo&.blob
      end
    else
      element['blob'] = find_blob element, 'logo'
    end
    element.to_dot
  end
end
