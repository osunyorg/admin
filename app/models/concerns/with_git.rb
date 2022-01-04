module WithGit
  extend ActiveSupport::Concern

  included do
    has_many  :git_files,
              class_name: "Communication::Website::GitFile",
              as: :about,
              dependent: :destroy
  end

  # Needs override
  def git_path_static
    raise NotImplementedError
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

  def sync_with_git
    websites.each do |website|
      identifiers.each do |identifier|
        Communication::Website::GitFile.sync website, self, identifier
        dependencies = send "git_dependencies_#{identifier}"
        dependencies.each do |object|
          Communication::Website::GitFile.sync website, object, identifier
        end
      end
      website.git_repository.sync!
    end
  end
  handle_asynchronously :sync_with_git

  protected

  # Overridden for multiple files generation
  def identifiers
    [:static]
  end

  def git_dependencies_static
    []
  end
end
