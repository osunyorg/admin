class Communication::Block::Template::OrganizationChart::Element < Communication::Block::Template::Base

  has_component :id, :person
  has_component :role, :string

  def person
    id_component.person
  end
end
