module Communication::Website::Agenda::Event::WithDays
  extend ActiveSupport::Concern

  included do
    has_many  :days,
              foreign_key: :communication_website_agenda_event_id
    after_save :generate_days
  end

  protected

  def generate_days
    # Days are used to group children
    return unless kind_parent?
    existing_days_ids = []
    date = from_day
    # Create missing days
    loop do 
      existing_days_ids.concat generate_day(date)
      date += 1.day
      break if date > to_day
    end
    # Remove extra useless days
    days.where.not(id: existing_days_ids).each do |day|
      day.destroy
    end
  end

  # Returns an array of ids
  def generate_day(date)
    website.languages.map do |language|
      day = days.where(
        university: university,
        website: website,
        language: language,
        date: date,
      ).first_or_create
      day.id
    end
  end
end