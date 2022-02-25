class Communication::Block::Template
  attr_reader :block

  def initialize(block)
    @block = block
  end

  def git_dependencies
    []
  end

  protected

  def data
    block.data
  end

  def university
    block.university
  end
end
