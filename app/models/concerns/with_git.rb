module WithGit
  extend ActiveSupport::Concern

  included do
    has_many  :git_files,
              class_name: "Communication::Website::GitFile",
              as: :about,
              dependent: :destroy
  end

  def sync_with_git
    websites.each do |website|
      identifiers.each do |identifier|
        git_file = git_files.where(website: website, about: self, identifier: identifier).first_or_create
        website.git_repository.add_git_file git_file
      end
      website.git_repository.sync!
    end
  end
  handle_asynchronously :sync_with_git


  def git_path_static
    ""
  end

  # Overridden for multiple files generation
  def identifiers
    [:static]
  end

  # Overridden if websites relation exists
  def websites
    [website]
  end

  protected

  def sync_git_files
    websites.each do |website|
      identifiers.each do |identifier|
        git_file = git_files.where(website: website, about: self, identifier: identifier).first_or_create
        website.sync_file git_file
      end
    end
  end
end
