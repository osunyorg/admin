class Communication::Website::Page::Researcher < Communication::Website::Page

  def is_necessary_for_website?
    website.about && website.about&.respond_to?(:researchers)
  end

  def dependencies
    super +
    [website.config_default_languages] +
    dependencies_researchers
  end

  # Not listed in any menu because it makes "Équipe" unclickable (opens submenu)
  def default_menu_identifier
    ''
  end

  def git_path_relative
    'researchers/_index.html'
  end

  protected

  def dependencies_researchers
    University::Person::Localization::Researcher.where(
      about_id: website.researchers.pluck(:id),
      language_id: website.active_language_ids
    )
  end

  def default_parent
    website.special_page(Communication::Website::Page::Person)
  end
end
