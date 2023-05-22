module WithBlocks
  extend ActiveSupport::Concern

  included do
    has_many :blocks, as: :about, class_name: 'Communication::Block', dependent: :destroy
  end

  # Basic rule is: TOC if 2 titles or more
  def show_toc?
    blocks.published
          .collect(&:title)
          .reject(&:blank?)
          .many?
  end
end
