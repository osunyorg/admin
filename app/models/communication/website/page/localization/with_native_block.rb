module Communication::Website::Page::Localization::WithNativeBlock
  extend ActiveSupport::Concern

  included do
    before_validation :create_native_block, if: :should_have_native_block?
    after_save :create_native_block, if: :should_have_native_block?
  end

  def create_native_block
    return if native_block_exists?
    Communication::Block.create(
      about: self,
      native: true,
      template_kind: page.native_block_template_kind
    )
  end
  
  protected

  def native_block_exists?
    blocks.native
          .for_template_kind(page.native_block_template_kind)
          .exists?          
  end

  def should_have_native_block?
    page.is_hugo_index? || page.children.any?
  end
end
