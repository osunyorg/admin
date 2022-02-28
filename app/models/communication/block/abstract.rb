class Communication::Block::Abstract
  attr_reader :block

  def initialize(block)
    @block = block
  end

  def git_dependencies
    []
  end

  protected

  def find_blob(object, key)
    id = object.dig(key, 'id')
    return if id.blank?
    university.active_storage_blobs.find id
  end

  def data
    block.data || {}
  end

  def elements
    data.has_key?('elements') ? data['elements']
                              : []
  end

  def university
    block.university
  end
end
