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
        Communication::Website::GitFile.sync website, self, identifier
        git_dependencies(identifier).each do |object|
          Communication::Website::GitFile.sync website, object, identifier
        end
      end
      website.git_repository.sync!
    end
  end
  handle_asynchronously :sync_with_git

  def git_path_static
    ''
  end

  def git_dependencies(identifier)
    []
  end

  # Overridden for multiple files generation
  def identifiers
    [:static]
  end

  # Overridden if websites relation exists
  def websites
    [website]
  end
end
