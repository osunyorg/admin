# == Schema Information
#
# Table name: communication_website_git_files
#
#  id            :uuid             not null, primary key
#  about_type    :string           not null
#  identifier    :string           default("static")
#  previous_path :string
#  previous_sha  :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid             not null
#  website_id    :uuid             not null
#
# Indexes
#
#  index_communication_website_git_files_on_website_id  (website_id)
#  index_communication_website_github_files_on_about    (about_type,about_id)
#
# Foreign Keys
#
#  fk_rails_...  (website_id => communication_websites.id)
#
class Communication::Website::GitFile < ApplicationRecord
  belongs_to :website, class_name: 'Communication::Website'
  belongs_to :about, polymorphic: true

  def self.sync(website, object, identifier)
    git_file = where(website: website, about: object, identifier: identifier).first_or_create
    website.git_repository.add_git_file git_file
  end

  def synchronized_with_git?
    git_sha == previous_sha
  end

  def should_create?
    !synchronized_with_git? || previous_path.nil? || previous_sha.nil?
  end

  def should_update?
    previous_path != path || previous_sha != sha
  end

  def should_destroy?
    # TODO
    false
  end

  def path
    about.send "git_path_#{identifier}"
  end

  def sha
    # Git SHA-1 is calculated from the String "blob <length>\x00<contents>"
    # Source: https://alblue.bandlem.com/2011/08/git-tip-of-week-objects.html
    OpenSSL::Digest::SHA1.hexdigest "blob #{to_s.bytesize}\x00#{to_s}"
  end

  def to_s
    @to_s ||= ApplicationController.render(
      template: "admin/#{about.class.name.underscore.pluralize}/#{identifier}",
      layout: false,
      assigns: { about.class.name.demodulize.downcase => about }
    )
  end

  protected

  def git_sha
    @git_sha ||= website.git_repository.git_sha previous_path
  end

  # def add_media_to_batch(github)
  #   return unless manifest_data[:has_media] && about.respond_to?(:active_storage_blobs)
  #   about.active_storage_blobs.each { |blob| add_blob_to_batch(github, blob) }
  # end
  #
  # def add_blob_to_batch(github, blob)
  #   github.add_to_batch github_blob_params(blob)
  # end
  #
  # def remove_from_github
  #   return unless github.valid?
  #   github.remove github_path, github_remove_commit_message
  #   remove_media_from_github
  # end
  #
  # def remove_media_from_github
  #   return unless manifest_data[:with_media] && about.respond_to?(:active_storage_blobs)
  #   about.active_storage_blobs.each { |blob| remove_blob_from_github(blob) }
  # end
  #
  # def remove_blob_from_github(blob)
  #   github.remove github_blob_path(blob), github_blob_remove_commit_message
  # end
  #
  # def github_params
  #   {
  #     path: manifest_data[:generated_path].call(self),
  #     previous_path: github_path,
  #     data: manifest_data[:data].call(self)
  #   }
  # end
  #
  # def github_blob_params(blob)
  #   blob.analyze unless blob.analyzed?
  #   {
  #     path: github_blob_path(blob),
  #     data: ApplicationController.render(
  #       template: 'active_storage/blobs/static',
  #       layout: false,
  #       assigns: { blob: blob }
  #     )
  #   }
  # end
  #
  # def github_blob_path(blob)
  #   "data/media/#{blob.id[0..1]}/#{blob.id}.yml"
  # end
  #
  # def github_commit_message
  #   "[#{about.class.name.demodulize} - #{manifest_identifier}] Save #{about.to_s}"
  # end
  #
  # def github_remove_commit_message
  #   "[#{about.class.name.demodulize} - #{manifest_identifier}] Remove #{about.to_s}"
  # end
  #
  # def github_blob_remove_commit_message(blob)
  #   "[Medium] Remove ##{blob.id}"
  # end
  #
  # def valid_for_publication?
  #   if about.respond_to?(:published)
  #     about.published?
  #   else
  #     true
  #   end
  # end
end
