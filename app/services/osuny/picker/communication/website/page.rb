class Osuny::Picker::Communication::Website::Page < Osuny::Picker

  def website
    context
  end

  def objects
    @objects ||= website.pages.ordered(language)
  end

  def categories
    @categories ||= website.page_categories
  end

  def sorts
    sort_add(I18n.t('communication.website.page.sort.alpha'), 'alpha')
  end

end