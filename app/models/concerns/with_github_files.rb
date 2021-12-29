module WithGithubFiles
  extend ActiveSupport::Concern

  included do
    has_many  :github_files,
              class_name: "Communication::Website::GithubFile",
              as: :about,
              dependent: :destroy

    after_save :create_github_files
    after_save_commit :publish_github_files
    after_save_commit :unpublish_github_files, if: :should_unpublish_github_files?
  end

  def force_publish!
    publish_github_files
  end

  def github_path_generated
    "content/#{self.class.name.demodulize.pluralize.underscore}/#{self.slug}/_index.html"
  end

  def to_static(github_file)
    ApplicationController.render(
      template: "admin/#{self.class.name.underscore.pluralize}/static",
      layout: false,
      assigns: { self.class.name.demodulize.underscore => self, github_file: github_file }
    )
  end

  def github_manifest
    [
      {
        identifier: "primary",
        generated_path: -> (github_file) { github_path_generated },
        data: -> (github_file) { to_static(github_file) },
        has_media: true
      }
    ]
  end

  protected

  def create_github_files
    list_of_websites.each do |website|
      github_manifest.each do |manifest_item|
        github_files.where(website: website, manifest_identifier: manifest_item[:identifier]).first_or_create
      end
    end
  end

  def publish_github_files
    if respond_to?(:descendents)
      publish_github_files_with_descendents
    else
      list_of_websites.each do |website|
        github_manifest.each do |manifest_item|
          github_file = github_files.where(website: website, manifest_identifier: manifest_item[:identifier]).first_or_create
          github_file.publish
        end
      end
    end
  end

  def publish_github_files_with_descendents
    list_of_websites.each do |current_website|
      website_github = Github.with_website current_website
      next unless website_github.valid?
      target_github_files = []
      github_manifest.each do |manifest_item|
        github_file = github_files.where(website: current_website, manifest_identifier: manifest_item[:identifier]).first_or_create
        target_github_files << github_file
        github_file.add_to_batch(website_github)
        descendents.each do |descendent|
          next unless descendent.list_of_websites.include? current_website
          descendent_github_file = descendent.github_files.where(website: current_website, manifest_identifier: manifest_item[:identifier]).first_or_create
          target_github_files << descendent_github_file
          descendent_github_file.add_to_batch(website_github)
        end
      end
      if website_github.commit_batch("[#{self.class.name.demodulize}] Save #{to_s} & descendents")
        target_github_files.each { |file|
          file.update_column :github_path, file.manifest_data[:generated_path].call(file)
        }
      end
    end
  end

  def unpublish_github_files
    list_of_websites.each do |current_website|
      github_manifest.each do |manifest_item|
        github_files.find_by(website: current_website, manifest_identifier: manifest_item[:identifier])&.unpublish
      end
    end
  end

  def should_unpublish_github_files?
    respond_to?(:published?) && saved_change_to_published? && !published?
  end

  def list_of_websites
    respond_to?(:websites) ? websites : [website]
  end
end
