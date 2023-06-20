module WithBlocks
  extend ActiveSupport::Concern

  included do
    has_many :blocks, as: :about, class_name: 'Communication::Block', dependent: :destroy
    has_many :headings, as: :about, class_name: 'Communication::Block::Heading', dependent: :destroy
  end

  def content
    unless @content
      @content = []
      blocks.without_heading.published.ordered.each do |block|
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
    headings.many?
  end
end
