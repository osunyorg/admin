class Osuny::Picker::Communication::Website::Page < Osuny::Picker

  def website
    context
  end

  def objects
    @objects ||= website.pages
  end

  def categories
    @categories ||= website.page_categories
  end

end