class Communication::Website::Page::Home < Communication::Website::Page

  def full_width_by_default?
    true
  end

  def draftable?
    false
  end

  protected

  def current_git_path
    @current_git_path ||= "#{git_path_prefix}_index.html"
  end

  def default_parent
    nil
  end

  def set_slug
    self.slug = ''
  end

  def validate_slug
    true
  end

end
