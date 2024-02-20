class Communication::Website::Page::Author < Communication::Website::Page

  def dependencies
    super +
    [website.config_default_languages] +
    website.authors.where(language_id: language_id).map(&:author)
  end

  # Not listed in any menu because it makes "Équipe" unclickable (opens submenu)
  def default_menu_identifier
    ''
  end

  def git_path_relative
    'authors/_index.html'
  end

  protected

  def default_parent
    website.special_page(Communication::Website::Page::Person, language: language)
  end
end
