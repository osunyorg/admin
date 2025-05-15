module HasGitFiles
  extend ActiveSupport::Concern

  included do
    include GeneratesGitFiles
    
    has_many  :git_files,
              class_name: "Communication::Website::GitFile",
              as: :about
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

end
