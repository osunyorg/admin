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

  def path
    @path ||= about.git_path(website)&.gsub(/\/+/, '/')
  end

  def to_s
    @to_s ||= Static.render(template_static, about, website)
  end

  protected

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
