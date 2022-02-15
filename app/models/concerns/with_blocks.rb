module WithBlocks
  extend ActiveSupport::Concern

  included do
    has_many :blocks, as: :about
  end

  def git_block_dependencies
    blocks.collect &:git_dependencies
  end
end
