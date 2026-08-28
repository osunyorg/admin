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

  def sorts
    sort_add(:alpha)
    sort_add(:date_asc)
    sort_add(:date_desc)
  end

end