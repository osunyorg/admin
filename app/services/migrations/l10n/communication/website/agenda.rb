class Migrations::L10n::Communication::Website::Agenda < Migrations::L10n::Base
  def self.execute
    Event.execute
    Category.execute
    reconnect_objects_to_categories Communication::Website::Agenda::Event
  end
end