class Communication::Block::Template
  attr_reader :block

  def initialize(block)
    @block = block
  end

  def sanitized_data
    data
  end

  def git_dependencies
    unless @git_dependencies
      @git_dependencies = []
      build_git_dependencies
      @git_dependencies.uniq!
    end
    @git_dependencies
  end

  def active_storage_blobs
    []
  end

  protected

  def build_git_dependencies
  end

  def add_dependency(dependency)
    if dependency.is_a? Array
      @git_dependencies += dependency
    else
      @git_dependencies += [dependency]
    end
  end

  def find_blob(object, key)
    id = object.dig(key, 'id')
    return if id.blank?
    university.active_storage_blobs.find id
  end

  def extract_image_alt_and_credit(source, variable)
    blob = find_blob source, variable
    return if blob.nil?
    alt = source["alt"] || source["#{variable}_alt"]
    credit = source["credit"] || source["#{variable}_credit"]
    text = source["text"] || source["#{variable}_text"]
    {
      blob: blob,
      alt: alt,
      credit: credit,
      text: text
    }.to_dot
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
