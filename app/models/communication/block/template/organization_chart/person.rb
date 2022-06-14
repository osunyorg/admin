class Communication::Block::Template::OrganizationChart::Person < Communication::Block::Template::Base

  has_select :person
  has_string :role

end
