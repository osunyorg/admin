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
  # We don't include Sanitizable as this model is never handled by users directly.

  belongs_to :website, class_name: 'Communication::Website'
  belongs_to :about, polymorphic: true

  attr_accessor :will_be_destroyed

  def self.sync(website, object, destroy: false)
    # A dependency does not always have a GitFile (ex: Communication::Block)
    return unless object.respond_to?(:git_files)
    # Permalinks must be calculated BEFORE renders
    manage_permalink object, website
    # Blobs need to be completely analyzed, which is async
    analyze_if_blob object
    # The git file might exist or not
    git_file = where(website: website, about: object).first_or_create
    # Mark for destruction if necessary
    git_file.will_be_destroyed = destroy
    # It is very important to go through this specific instance of the website,
    # and not through each git_file.website, which would be different instances.
    # Otherwise, we get 1 instance of git_repository per git_file,
    # and it causes a huge amount of useless queries.
    website.git_repository.add_git_file git_file
  end

  def path
    @path ||= about.git_path(website)&.gsub(/\/+/, '/')
  end

  def to_s
    @to_s ||= Static.render(template_static, about, website)
  end

  protected

  def self.manage_permalink(object, website)
    return unless Communication::Website::Permalink.supported_by?(object)
    object.manage_permalink_in_website(website)
  end

  def self.analyze_if_blob(object)
    return unless object.is_a? ActiveStorage::Blob
    object.analyze unless object.analyzed?
  end

  def template_static
    if about.respond_to? :template_static
      about.template_static
    else
      "admin/#{about.class.name.underscore.pluralize}/static"
    end
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
end
