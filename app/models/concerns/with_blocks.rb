module WithBlocks
  extend ActiveSupport::Concern

  included do
    has_many :blocks, as: :about, class_name: 'Communication::Block', dependent: :destroy
    has_many :headings, as: :about, class_name: 'Communication::Block::Heading', dependent: :destroy
  end

  def git_block_dependencies
    blocks.collect &:git_dependencies
  end

  def content
    unless @content
      @content = []
      blocks.with_no_heading.published.ordered.each do |block|
        @content << block
      end
      headings.ordered.each do |heading|
        @content << heading
      end
    end
    @content
  end

  # Basic rule is: TOC if 2 titles or more
  def show_toc?
    blocks.published
          .collect(&:title)
          .reject(&:blank?)
          .many?
  end
end
