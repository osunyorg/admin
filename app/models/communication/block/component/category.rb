class Communication::Block::Component::Category < Communication::Block::Component::Base

  def category
    return unless website
    website.categories.find_by(id: data)
  end

  def git_dependencies
    active_storage_blobs +
    [category]
  end

  def active_storage_blobs
    category&.active_storage_blobs || []
  end
end
