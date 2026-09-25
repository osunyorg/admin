class Osuny::Picker::Communication::Website::Agenda::Event < Osuny::Picker

  def website
    context
  end

  def objects
    @objects ||= website.agenda_events.except_templates
  end

  def categories
    @categories ||= website.agenda_categories
  end

  def sorts
    sort_add(:date_desc)
    sort_add(:date_asc)
  end

end