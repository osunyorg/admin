module WithWithGitSync
  extend ActiveSupport::Concern

  included do
    after_save :add_to_git_batch
  end

  protected

  def list_of_websites
    respond_to?(:websites) ? websites : [website]
  end

  def add_to_git_batch
    list_of_websites.each do |website|
      file = Git::File.new
      file.path = github_path_generated
      file.previous_path
    end
  end
end
