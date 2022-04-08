class Communication::Block::Template::Partner < Communication::Block::Template
  def build_git_dependencies
    add_dependency organizations
    add_dependency blobs
  end

  def partners
    unless @partners
      @partners = []
      elements.each do |element|
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
        @partners << element.to_dot
      end
    end
    @partners
  end

  protected

  def organizations
    unless @organizations
      @organizations = []
      partners.each do |partner|
        next if partner.organization.nil?
        @organizations << partner.organization
      end
    end
    @organizations
  end

  def blobs
    unless @blobs
      @blobs = []
      partners.each do |partner|
        next if partner.blob.nil?
        @blobs << partner.blob
      end
    end
    @blobs
  end
end
