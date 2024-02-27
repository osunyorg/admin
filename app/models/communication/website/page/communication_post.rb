class Communication::Website::Page::CommunicationPost < Communication::Website::Page

  def editable_width?
    false
  end

  def full_width_by_default?
    true
  end

  def dependencies
    super +
    [website.config_default_languages] +
    website.post_categories.where(language_id: language_id) +
    website.posts.where(language_id: language_id)
  end

  def git_path_relative
    'posts/_index.html'
  end
end
