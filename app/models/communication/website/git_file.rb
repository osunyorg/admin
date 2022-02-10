# == Schema Information
#
# Table name: communication_website_git_files
#
#  id            :uuid             not null, primary key
#  about_type    :string           not null, indexed => [about_id]
#  previous_path :string
#  previous_sha  :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid             not null, indexed => [about_type]
#  website_id    :uuid             not null, indexed
#
# Indexes
#
#  index_communication_website_git_files_on_website_id  (website_id)
#  index_communication_website_github_files_on_about    (about_type,about_id)
#
# Foreign Keys
#
#  fk_rails_8505d649e8  (website_id => communication_websites.id)
#
class Communication::Website::GitFile < ApplicationRecord
  belongs_to :website, class_name: 'Communication::Website'
  belongs_to :about, polymorphic: true

  attr_accessor :will_be_destroyed

  def self.sync(website, object, destroy: false)
    git_file = where(website: website, about: object).first_or_create
    git_file.will_be_destroyed = destroy
    website.git_repository.add_git_file git_file
  end

  def synchronized_with_git?
    git_sha == previous_sha
  end

  def should_create?
    !should_destroy? &&
    (
      !synchronized_with_git? ||
      previous_path.nil? ||
      previous_sha.nil?
    )
  end

  def should_update?
    !should_destroy? &&
    (
      previous_path != path ||
      previous_sha != sha
    )
  end

  def should_destroy?
    will_be_destroyed || path.nil?
  end

  def path
    @path ||= about.git_path(website)&.gsub(/\/+/, '/')
  end

  def sha
    # Git SHA-1 is calculated from the String "blob <length>\x00<contents>"
    # Source: https://alblue.bandlem.com/2011/08/git-tip-of-week-objects.html
    @sha ||= OpenSSL::Digest::SHA1.hexdigest "blob #{to_s.bytesize}\x00#{to_s}"
  end

  def to_s
    @to_s ||= ApplicationController.render(
      template: "admin/#{about.class.name.underscore.pluralize}/static",
      layout: false,
      assigns: {
        about.class.name.demodulize.downcase => about,
        website: website
      }
    )
  end

  protected

  def git_sha
    @git_sha ||= website.git_repository.git_sha previous_path
  end
end
