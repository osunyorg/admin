module Contentful
  extend ActiveSupport::Concern

  LARGE_NUMBER_OF_BLOCKS = 5

  included do
    has_many  :blocks,
              as: :about,
              class_name: 'Communication::Block',
              dependent: :destroy

    accepts_nested_attributes_for :blocks, allow_destroy: true
  end

  def contents
    @contents ||= blocks.published.ordered
  end

  def contents_full_text
    @contents_full_text ||= contents.collect(&:full_text)
                                    .reject(&:blank?)
                                    .join(" ")
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

  def generate_blocks(template_blocks)
    template_blocks.each { |hash| generate_block(hash.dup) }
  end

  protected

  def generate_block(hash)
    hash[:university] = university
    hash[:published] = true unless hash.has_key?(:published)
    prepare_template_block_data!(hash)
    blocks.create(hash)
  end

  def prepare_template_block_data!(hash)
    data = hash.has_key?(:data) ? hash[:data] : {}
    data = data.to_json
    data = data.gsub('{website}', website.to_s)
    data = data.gsub('{website.url}', website.url)
    hash[:data] = data
  end
end
