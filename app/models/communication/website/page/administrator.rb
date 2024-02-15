class Communication::Website::Page::Administrator < Communication::Website::Page

  def is_necessary_for_website?
    website.about && website.about&.respond_to?(:administrators)
  end

  def dependencies
    super +
    [website.config_default_languages] +
    website.administrators.where(language_id: language_id).map(&:administrator)
  end

  # Not listed in any menu because it makes "Équipe" unclickable (opens submenu)
  def default_menu_identifier
    ''
  end

  protected

  def current_git_path
    @current_git_path ||= "#{git_path_prefix}administrators/_index.html"
  end

  def default_parent
    website.special_page(Communication::Website::Page::Person, language: language)
  end


end
