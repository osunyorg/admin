module WithReferenceBlocks
  extend ActiveSupport::Concern

  included do
    after_save    :generate_reference_block_about_git_files
    after_destroy :generate_reference_block_about_git_files
    after_restore :generate_reference_block_about_git_files if paranoid?
    after_touch   :generate_reference_block_about_git_files
  end

  protected

  def generate_reference_block_about_git_files
    websites.each do |website|
      Communication::Website::GenerateBlockAboutsContentJob.perform_later(website, reference_block_template_kind)
    end
  end

  def reference_block_template_kind
    raise NoMethodError, "You must implement reference_block_template_kind in #{self.class.name}"
  end
end
