class Communication::Block::Gallery < Communication::Block::Abstract
  def git_dependencies
    dependencies = []
    elements.each do |image|
      id = image.dig('file', 'id')
      next if id.blank?
      blob = university.active_storage_blobs.find id
      next if blob.nil?
      dependencies += [blob]
    end
    dependencies.uniq
  end
end
