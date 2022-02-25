class Communication::Block::Gallery < Communication::Block::Template
  def git_dependencies
    dependencies = []
    data['elements'].each do |image|
      id = image.dig('file', 'id')
      next if id.blank?
      blob = university.active_storage_blobs.find id
      next if blob.nil?
      dependencies += [blob]
    end
    dependencies.uniq
  end
end
