# == Schema Information
#
# Table name: communication_website_github_files
#
#  id                  :uuid             not null, primary key
#  about_type          :string           not null
#  github_path         :string
#  manifest_identifier :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  about_id            :uuid             not null
#  website_id          :uuid             not null
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

  def needs_sync?
    false
  end

  def publish
    return unless valid_for_publication? && github.valid?
    add_to_batch(github)
    if github.commit_batch(github_commit_message)
      update_column :github_path, manifest_data[:generated_path].call(self)
    end
  end
  handle_asynchronously :publish, queue: 'default'

  def unpublish
    remove_from_github
  end
  handle_asynchronously :unpublish, queue: 'default'

  def add_to_batch(github)
    return unless valid_for_publication?
    github.add_to_batch github_params
    add_media_to_batch(github)
  end

  def manifest_data
    @manifest_data ||= about.github_manifest.detect { |item|
      item[:identifier] == manifest_identifier
    }
  end

  protected

  def add_media_to_batch(github)
    return unless manifest_data[:has_media] && about.respond_to?(:active_storage_blobs)
    about.active_storage_blobs.each { |blob| add_blob_to_batch(github, blob) }
  end

  def add_blob_to_batch(github, blob)
    github.add_to_batch github_blob_params(blob)
  end

  def remove_from_github
    return unless github.valid?
    github.remove github_path, github_remove_commit_message
    remove_media_from_github
  end

  def remove_media_from_github
    return unless manifest_data[:with_media] && about.respond_to?(:active_storage_blobs)
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
      path: manifest_data[:generated_path].call(self),
      previous_path: github_path,
      data: manifest_data[:data].call(self)
    }
  end

  def github_blob_params(blob)
    blob.analyze unless blob.analyzed?
    {
      path: github_blob_path(blob),
      data: ApplicationController.render(
        template: 'active_storage/blobs/static',
        layout: false,
        assigns: { blob: blob }
      )
    }
  end

  def github_blob_path(blob)
    "data/media/#{blob.id[0..1]}/#{blob.id}.yml"
  end

  def github_commit_message
    "[#{about.class.name.demodulize} - #{manifest_identifier}] Save #{about.to_s}"
  end

  def github_remove_commit_message
    "[#{about.class.name.demodulize} - #{manifest_identifier}] Remove #{about.to_s}"
  end

  def github_blob_remove_commit_message(blob)
    "[Medium] Remove ##{blob.id}"
  end

  def valid_for_publication?
    if about.respond_to?(:published)
      about.published?
    else
      true
    end
  end
end
