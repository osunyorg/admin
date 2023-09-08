class Communication::Website::Page::CommunicationAgendaArchive < Communication::Website::Page
  def editable_width?
    false
  end

  def full_width_by_default?
    true
  end

  def is_necessary_for_website?
    website.feature_agenda
  end

  def dependencies
    super +
    [website.config_default_languages] +
    website.events
  end

  def default_parent
    website.special_page(Communication::Website::Page::CommunicationAgenda, language: language)
  end

  protected

  def current_git_path
    @current_git_path ||= "#{git_path_prefix}events/archives/_index.html"
  end
end