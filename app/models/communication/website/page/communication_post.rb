class Communication::Website::Page::CommunicationPost < Communication::Website::Page

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
    website.feature_posts
  end

  def dependencies
    super +
    [website.config_default_languages] +
    website.post_categories +
    website.posts
  end

  def git_path_relative
    'posts/_index.html'
  end

  def special_page_categories
    website.post_categories
  end

  def hugo_body_class
    'posts__section'
  end
end
