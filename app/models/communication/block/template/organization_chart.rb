class Communication::Block::Template::OrganizationChart < Communication::Block::Template::Base

  has_elements
  has_component :description, :rich_text
  has_component :with_link, :boolean

end
