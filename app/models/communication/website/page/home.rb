class Communication::Website::Page::Home < Communication::Website::Page

  def full_width_by_default?
    true
  end

  def draftable?
    false
  end

  def git_path_relative
    '_index.html'
  end

  def default_parent
    nil
  end
end
