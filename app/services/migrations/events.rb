class Migrations::Events
  def self.migrate
    Communication::Website::Agenda::Event.where(to_day: nil).find_each &:save
  end
end