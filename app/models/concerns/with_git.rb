module WithGit
  extend ActiveSupport::Concern
  
  included do
    # WithGit a besoin de WithDependencies et WithReferences
    include WithDependencies
    include WithReferences

    has_many  :git_files,
              class_name: "Communication::Website::GitFile",
              as: :about,
              dependent: :destroy
  end

  def git_path(website)
    raise NotImplementedError
  end

  def git_path_content_prefix(website)
    # Handle language-less objects
    # TODO I18n: Right now, we use the language of the object, fallbacking on the language of the website. In the end, we'll only use the language of the object
    path = "content/"
    path_language = respond_to?(:language_id) && language_id.present? ? language : website.default_language
    path += "#{path_language.iso_code}/"
    path
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
    destroy_from_git
    destroy
  end

  def sync_with_git
    websites_for_self.each do |website|
      next unless website.git_repository.valid?
      Communication::Website::GitFile.sync website, self
      recursive_dependencies.each do |object|
        Communication::Website::GitFile.sync website, object
      end
      references.each do |object|
        Communication::Website::GitFile.sync website, object
      end
      website.git_repository.sync!
    end
  end
  handle_asynchronously :sync_with_git, queue: 'default'

  def destroy_from_git
    websites.each do |website|
      next unless website.git_repository.valid?
      Communication::Website::GitFile.sync website, self, destroy: true
      # # FIXME
      # dependencies = git_destroy_dependencies(website).to_a.flatten.uniq.compact
      # dependencies.each do |object|
      #   Communication::Website::GitFile.sync website, object, destroy: true
      # end
      website.git_repository.sync!
    end
  end
  
  protected

  def websites_for_self
    if is_a? Communication::Website
      [self]
    elsif respond_to?(:website)
      [website]
    elsif respond_to?(:websites)
      websites
    else
      []
    end
  end
end
