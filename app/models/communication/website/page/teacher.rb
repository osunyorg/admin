class Communication::Website::Page::Teacher < Communication::Website::Page

  def is_hugo_index?
    true
  end

  def should_create_special_page?
    website.about && website.about&.respond_to?(:teachers)
  end

  # Not listed in any menu because it makes "Équipe" unclickable (opens submenu)
  def default_menu_identifier
    ''
  end

  def dependencies
    super +
    [website.config_default_languages] +
    dependencies_teachers
  end

  def git_path_relative
    'teachers/_index.html'
  end

  protected

  def dependencies_teachers
    University::Person::Localization::Teacher.where(
      about_id: website.teachers.pluck(:id),
      language_id: website.active_language_ids
    )
  end

  def default_parent
    website.special_page(Communication::Website::Page::Person)
  end
end
