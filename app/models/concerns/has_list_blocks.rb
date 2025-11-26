module HasListBlocks
  extend ActiveSupport::Concern

  included do
    after_save    :synchronize_list_blocks
    after_destroy :synchronize_list_blocks
    after_restore :synchronize_list_blocks if paranoid?
    after_touch   :synchronize_list_blocks
  end

  protected

  def synchronize_list_blocks
    websites.each do |website|
      Communication::Website::SynchronizeListBlocksJob.perform_later(website, list_blocks_template_kind)
    end
  end

  def list_blocks_template_kind
    raise NoMethodError, "You must implement list_blocks_template_kind in #{self.class.name}"
  end
end
