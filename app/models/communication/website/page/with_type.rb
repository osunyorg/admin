module Communication::Website::Page::WithType
  extend ActiveSupport::Concern

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