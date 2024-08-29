class Communication::Block::Component::Organization < Communication::Block::Component::Base

  def organization
    template.block
            .university
            .organizations
            .tmp_original # TODO L10N : To remove
            .for_language(template.block.language)
            .find_by(id: data)
  end

  def dependencies
    [organization]
  end

end
