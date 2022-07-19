class Communication::Block::Template::Contact < Communication::Block::Template::Base

  has_component :name, :string
  has_component :phone_numbers, :array
  has_component :emails, :array
  # Address
  has_component :street, :string
  has_component :locality, :string
  has_component :postal_code, :string
  has_component :country, :string
  # Timetable
  has_elements

end
