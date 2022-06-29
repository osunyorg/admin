class Communication::Block::Template::OrganizationChart < Communication::Block::Template::Base

  has_elements
  has_component :description, :rich_text
  has_component :with_link, :boolean
  has_component :with_photo, :boolean

end
