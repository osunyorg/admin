module WithBlocks
  extend ActiveSupport::Concern

  included do
    has_many :blocks, as: :about, class_name: 'Communication::Block', dependent: :destroy
    has_many :headings, as: :about, class_name: 'Communication::Block::Heading', dependent: :destroy
  end

  def contents
    unless @contents
      @contents = []
      blocks.without_heading.published.ordered.each do |block|
        @contents << block
      end
      headings.ordered.each do |heading|
        @contents << heading
        @contents.concat heading.blocks
      end
    end
    @contents
  end

  def contents_full_text
    @contents_full_text ||= contents.collect(&:full_text).join("\r")
  end

  # Basic rule is: TOC if 2 titles or more
  def show_toc?
    headings.many?
  end
end
