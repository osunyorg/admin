class Communication::Block::Component::Person < Communication::Block::Component::Base

  def person
    template.block
            .university
            .people
            .tmp_original # TODO L10N : To remove
            .find_by(id: data)
  end

  def dependencies
    [person]
  end

end
