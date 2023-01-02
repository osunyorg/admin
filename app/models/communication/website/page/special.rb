class Communication::Website::Page::Special < Communication::Website::Page
  def is_necessary?
    true
  end

  def full_width_by_default?
    true
  end

  def published_by_default?
    true
  end

  def unpublishable?
    true
  end
end
