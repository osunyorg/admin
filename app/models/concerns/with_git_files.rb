module WithGitFiles
  extend ActiveSupport::Concern

  included do
    has_many  :git_files,
              class_name: "Communication::Website::GitFile",
              as: :about

    after_save :generate_git_files
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

  protected

  def generate_git_files
    # TODO iteration 11: for an indirect object this depends on the presence of websites, so on established connections.
    # for instance a l10n which is currently an indirect object has no websites on the creation 
    # git_files should probably been created just after connexions
    websites.each do |website|
      Communication::Website::GitFile.generate website, self
    end
  end
end
