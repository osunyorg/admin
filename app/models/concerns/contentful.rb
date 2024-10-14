module Contentful
  extend ActiveSupport::Concern

  LARGE_NUMBER_OF_BLOCKS = 5

  included do
    has_many :blocks, as: :about, class_name: 'Communication::Block', dependent: :destroy
    has_many :headings, as: :about, class_name: 'Communication::Block::Heading', dependent: :destroy
  end

  def contents
    @contents ||= blocks.published.ordered
  end

  def contents_full_text
    @contents_full_text ||= contents.collect(&:full_text).join("\r")
  end

  def contents_dependencies
    blocks
  end

  def large_number_of_blocks?
    blocks.count >= LARGE_NUMBER_OF_BLOCKS
  end

  # Basic rule is: TOC if 2 titles or more
  def show_toc?
    blocks.template_title.published.many?
  end

  def generate_block(kind, title: nil, data: {})
    blocks.create(university: university, template_kind: kind, title: title, data: data.to_json)
  end
end
