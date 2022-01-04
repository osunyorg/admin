module WithGit
  extend ActiveSupport::Concern

  included do
    has_many  :git_files,
              class_name: "Communication::Website::GitFile",
              as: :about,
              dependent: :destroy
  end

  def git_path_static
    ''
  end

  # Overridden if websites relation exists
  def websites
    [website]
  end

  def save_and_sync
    if save
      sync_with_git
      true
    else
      false
    end
  end

  def update_and_sync(params)
    if update(params)
      sync_with_git
      true
    else
      false
    end
  end

  def destroy_and_sync
    # TODO
    destroy
  end

  protected

  # Overridden for multiple files generation
  def identifiers
    [:static]
  end

  def git_dependencies(identifier)
    []
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
end
