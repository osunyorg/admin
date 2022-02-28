class Communication::Block::Partner < Communication::Block::Abstract
  def git_dependencies
    dependencies = []
    elements.each do |partner|
      id = partner.dig('logo', 'id')
      next if id.blank?
      blob = university.active_storage_blobs.find id
      next if blob.nil?
      dependencies += [blob]
    end
    dependencies.uniq
  end
end
