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

end