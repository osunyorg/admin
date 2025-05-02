module HasGitFiles
  extend ActiveSupport::Concern

  included do
    has_many  :git_files,
              class_name: "Communication::Website::GitFile",
              as: :about
    
    after_save  :generate_git_file
    after_touch :generate_git_file
  end

  def git_path(website)
    raise NotImplementedError
  end

  def git_path_relative
    raise NotImplementedError
  end

  def exportable_to_git?
    true
  end

  def git_path_content_prefix(website)
    # Handle language-less objects
    # TODO I18n: Right now, we use the language of the object, fallbacking on the language of the website. In the end, we'll only use the language of the object
    path = "content/"
    path_language = respond_to?(:language_id) && language_id.present? ? language : website.default_language
    path += "#{path_language.iso_code}/"
    path
  end

  def generate_git_files
    return unless respond_to?(:git_files)
    websites.each do |website|
      # Generate will skip if not needed on website
      Communication::Website::GitFile.generate website, self
      recursive_dependencies(syncable_only: true).each do |object|
        Communication::Website::GitFile.generate website, object
      end if respond_to?(:recursive_dependencies)
      references.each do |object|
        Communication::Website::GitFile.generate website, object
      end if respond_to?(:references)
    end
  end
end
