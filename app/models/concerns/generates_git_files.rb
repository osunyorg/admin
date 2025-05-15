module GeneratesGitFiles
  extend ActiveSupport::Concern

  included do
    after_save  :identify_git_files
    after_touch :identify_git_files
  end

  # Generate will skip if not needed on website
  def identify_git_files_safely
    websites.each do |website|
      website.generate_git_file_for_object(self)
      website.generate_git_file_for_array(recursive_dependencies(syncable_only: true)) if respond_to?(:recursive_dependencies)
      website.generate_git_file_for_array(references) if respond_to?(:references)
    end
  end

  protected

  def identify_git_files
    Communication::Website::GitFile::IdentifyJob.perform_later(self)
  end
end
