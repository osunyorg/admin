class Communication::Website::Page::CommunicationAgenda < Communication::Website::Page

  def is_hugo_index?
    true
  end

  def editable_width?
    false
  end

  def full_width_by_default?
    true
  end

  def should_create_special_page?
    website.feature_agenda
  end

  def dependencies
    super +
    [website.config_default_languages] +
    website.events
  end

  def git_path_relative
    'events/_index.html'
  end

  def special_page_categories
    website.agenda_categories
  end

  def hugo_body_class
    'events__section'
  end
end
