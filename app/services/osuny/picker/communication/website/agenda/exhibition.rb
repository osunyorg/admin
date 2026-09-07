class Osuny::Picker::Communication::Website::Agenda::Exhibition < Osuny::Picker

  def website
    context
  end

  def objects
    @objects ||= website.agenda_exhibitions
  end

  def categories
    @categories ||= website.agenda_categories
  end

end