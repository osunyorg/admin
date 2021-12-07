# == Schema Information
#
# Table name: communication_website_github_files
#
#  id          :uuid             not null, primary key
#  about_type  :string           not null
#  github_path :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  about_id    :uuid             not null
#  website_id  :uuid             not null
#
# Indexes
#
#  index_communication_website_github_files_on_about       (about_type,about_id)
#  index_communication_website_github_files_on_website_id  (website_id)
#
# Foreign Keys
#
#  fk_rails_...  (website_id => communication_websites.id)
#
class Communication::Website::GithubFile < ApplicationRecord
  belongs_to :website, class_name: 'Communication::Website'
  belongs_to :about, polymorphic: true

  after_destroy :remove_from_github

  def publish
    return unless github.valid?
    params = github_params.merge({
      commit: github_commit_message
    })
    if github.publish(params)
      update_column :github_path, about.github_path_generated
      publish_media
    end
  end
  handle_asynchronously :publish, queue: 'default'

  def publish_media
    return unless about.respond_to?(:active_storage_blobs)
    about.active_storage_blobs.each { |blob| publish_blob(blob) }
  end

  def publish_blob(blob)
    return unless github.valid?
    params = github_blob_params(blob).merge({
      commit: github_blob_commit_message(blob)
    })
    github.publish(params)
  end
  handle_asynchronously :publish_blob, queue: 'default'

  def add_to_batch(github)
    github.add_to_batch github_params
    add_media_to_batch(github)
  end

  def add_media_to_batch(github)
    return unless about.respond_to?(:active_storage_blobs)
    about.active_storage_blobs.each { |blob| add_blob_to_batch(github, blob) }
  end

  def add_blob_to_batch(github, blob)
    github.add_to_batch github_blob_params(blob)
  end

  def github_frontmatter
    @github_frontmatter ||= begin
      github_content = github.read_file_at(github_path)
      FrontMatterParser::Parser.new(:md).call(github_content)
    rescue
      FrontMatterParser::Parser.new(:md).call('')
    end
  end

  protected

  def remove_from_github
    return unless github.valid?
    github.remove github_path, github_remove_commit_message
    remove_media_from_github
  end

  def remove_media_from_github
    return unless about.respond_to?(:active_storage_blobs)
    about.active_storage_blobs.each { |blob| remove_blob_from_github(blob) }
  end

  def remove_blob_from_github(blob)
    github.remove github_blob_path(blob), github_blob_remove_commit_message
  end

  def github
    @github ||= Github.with_website(website)
  end

  def github_params
    {
      path: about.github_path_generated,
      previous_path: github_path,
      data: about.to_jekyll(self)
    }
  end

  def github_blob_params(blob)
    blob.analyze unless blob.analyzed?
    {
      path: github_blob_path(blob),
      data: ApplicationController.render(
        template: 'active_storage/blobs/jekyll',
        layout: false,
        assigns: { blob: blob }
      )
    }
  end

  def github_blob_path(blob)
    "_data/media/#{blob.id[0..1]}/#{blob.id}.yml"
  end

  def github_commit_message
    "[#{about.class.name.demodulize}] Save #{about.to_s}"
  end

  def github_blob_commit_message(blob)
    "[Medium] Save ##{blob.id}"
  end

  def github_remove_commit_message
    "[#{about.class.name.demodulize}] Remove #{about.to_s}"
  end

  def github_blob_remove_commit_message(blob)
    "[Medium] Remove ##{blob.id}"
  end
end
