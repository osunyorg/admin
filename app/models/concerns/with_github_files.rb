module WithGithubFiles
  extend ActiveSupport::Concern

  included do
    has_many :github_files, class_name: "Communication::Website::GithubFile", as: :about, dependent: :destroy

    after_save_commit :publish_github_files
    after_touch :publish_github_files
  end

  def force_publish!
    publish_github_files
  end

  def github_path_generated
    "_#{self.class.name.demodulize.pluralize.underscore}/#{self.id}.md"
  end

  def to_jekyll(github_file)
    ApplicationController.render(
      template: "admin/#{self.class.name.underscore.pluralize}/jekyll",
      layout: false,
      assigns: { self.class.name.demodulize.underscore => self, github_file: github_file }
    )
  end

  protected

  def publish_github_files
    list_of_websites = respond_to?(:websites) ? websites : [website]
    list_of_websites.each do |website|
      github_file = github_files.where(website: website).first_or_create
      github_file.publish
    end
  end
end
