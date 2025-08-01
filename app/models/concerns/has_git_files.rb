module HasGitFiles
  extend ActiveSupport::Concern

  included do
    include GeneratesGitFiles

    has_many  :git_files,
              class_name: "Communication::Website::GitFile",
              as: :about
  end

  def git_path(website)
    git_path_content_prefix(website) + git_path_relative
  end

  def git_path_relative
    raise NoMethodError, "You must implement the `git_path_relative` method in #{self.class.name}"
  end

  def can_have_git_file?
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

end
