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
    # Handle optional before-sync process
    object.before_git_sync
    git_file = where(website: website, about: object).first_or_create
    git_file.will_be_destroyed = destroy
    website.git_repository.add_git_file git_file
  end

  def should_create?
    !should_destroy? &&
    !exists_on_git? &&
    (
      !synchronized_with_git? ||
      previous_path.nil? ||
      previous_sha.nil?
    )
  end

  def should_update?
    !should_destroy? &&
    (
      different_path? ||
      different_sha?
    )
  end

  def should_destroy?
    will_be_destroyed ||
    path.nil?
  end

  def path
    @path ||= about.git_path(website)&.gsub(/\/+/, '/')
  end

  def to_s
    @to_s ||= ApplicationController.render(
      template: template_static,
      layout: false,
      assigns: {
        about: about,
        website: website
      }
    )
  end

  protected

  def template_static
    "admin/#{about.class.name.underscore.pluralize}/static"
  end

  # Real sha on the git repo
  def git_sha_for(path)
    website.git_repository.git_sha path
  end

  def previous_git_sha
    @previous_git_sha ||= git_sha_for(previous_path)
  end

  def git_sha
    @git_sha ||= git_sha_for(path)
  end

  # Based on content, with the provider's algorithm (sha1 or sha256)
  def computed_sha
    @computed_sha ||= website.git_repository.computed_sha to_s
  end

  def exists_on_git?
    previous_git_sha.present? || # The file exists where it was last time
    (
      previous_path.nil? && # Never saved in the database
      git_sha.present?      # but it exists in the git repo
    )
  end

  def synchronized_with_git?
    exists_on_git? && # File exists
    previous_path == path && # at the same place
    previous_git_sha == previous_sha # with the same content
  end

  def different_path?
    previous_path != path
  end

  def different_sha?
    previous_sha != computed_sha
  end
end
