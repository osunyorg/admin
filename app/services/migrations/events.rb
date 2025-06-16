class Migrations::Events
  def self.migrate
    Communication::Website::Agenda::Event.where(to_day: nil).find_each do |event|
      to_day = event.from_day
      if event.children.any?
        to_day = event.children.ordered.last.to_day
      elsif event.time_slots.any?
        to_day = event.time_slots.ordered.last.datetime.to_date
      end
      event.update_column :to_day, to_day
    end
  end
end