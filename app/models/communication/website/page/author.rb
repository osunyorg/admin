class Communication::Website::Page::Author < Communication::Website::Page

  def is_hugo_index?
    true
  end

  def dependencies
    super +
    [website.config_default_languages] +
    dependencies_authors
  end

  # Not listed in any menu because it makes "Équipe" unclickable (opens submenu)
  def default_menu_identifier
    ''
  end

  def git_path_relative
    'authors/_index.html'
  end

  protected

  def dependencies_authors
    University::Person::Localization::Author.where(
      about_id: website.authors.pluck(:id),
      language_id: website.active_language_ids
    )
  end

  def default_parent
    website.special_page(Communication::Website::Page::Person)
  end
end
