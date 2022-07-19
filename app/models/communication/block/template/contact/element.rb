class Communication::Block::Template::Contact::Element < Communication::Block::Template::Base
  has_component :title, :string
  # TODO: remplacer time_slot par 4 variables de temps (from to from to)
  has_component :time_slot_morning, :time_slot
  has_component :time_slot_afternoon, :time_slot
end
