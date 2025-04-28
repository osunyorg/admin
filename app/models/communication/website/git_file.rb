# == Schema Information
#
# Table name: communication_website_git_files
#
#  id                :uuid             not null, primary key
#  about_type        :string           not null, indexed => [about_id]
#  current_content   :text
#  current_path      :string
#  current_sha       :string
#  desynchronized    :boolean
#  desynchronized_at :datetime
#  previous_path     :string
#  previous_sha      :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  about_id          :uuid             not null, indexed => [about_type]
#  website_id        :uuid             not null, indexed
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

  attr_accessor :will_be_destroyed

  belongs_to :website, class_name: 'Communication::Website'
  belongs_to :about, polymorphic: true

  scope :desynchronized, -> { where(desynchronized: true) }
  scope :ordered, -> { order("communication_website_git_files.desynchronized_at DESC NULLS LAST, communication_website_git_files.updated_at DESC") }

  def self.sync(website, object)
    # All exportable objects must respond to this method
    # WithGitFiles defines it
    # AsDirectObject includes WithGitFiles, therefore all direct objects are exportable
    # AsIndirectObject does not include it, but some indirect objects have it (Person, Organization...)
    # Some objects need to declare that property:
    # - the website itself
    # - configs (which inherit from the website)
    # - active storage blobs
    return unless object.try(:exportable_to_git?)
    # Permalinks must be calculated BEFORE renders
    manage_permalink object, website
    # Blobs need to be completely analyzed, which is async
    analyze_if_blob object
    # The git file might exist or not
    git_file = where(website: website, about: object).first_or_create
    # It is very important to go through this specific instance of the website,
    # and not through each git_file.website, which would be different instances.
    # Otherwise, we get 1 instance of git_repository per git_file,
    # and it causes a huge amount of useless queries.
    website.git_repository.add_git_file git_file
  end

  # Simplified version of the sync method to simply delete an obsolete git_file
  # Not an instance method because we need to share the website's instance, and thus pass it as an argument
  def self.mark_for_destruction(website, git_file)
    git_file.will_be_destroyed = true
    website.git_repository.add_git_file git_file
  end

  def generate
    return if content_up_to_date?
    update(
      current_content: computed_content,
      current_path: computed_path,
      current_sha: computed_sha,
      desynchronized: true,
      desynchronized_at: Time.zone.now
    )
  end

  def generate_later
    Communication::Website::GenerateGitFileJob.perform_later(self)
  end

  def computed_path
    @computed_path ||= about.nil? ? nil : about.git_path(website)&.gsub(/\/+/, '/')
  end

  def computed_filename
    @computed_filename ||= File.basename(computed_path)
  end

  def content_up_to_date?
    current_content == computed_content
  end

  def synchronized?
    !desynchronized
  end

  def computed_content
    @computed_content ||= Static.render(template_static, about, website)
  end

  def computed_sha
    website.git_repository.computed_sha(computed_content)
  end

  def to_s
    "#{current_path}"
  end

  protected

  def self.manage_permalink(object, website)
    return unless Communication::Website::Permalink.supported_by?(object)
    object.manage_permalink_in_website(website)
  end

  def self.analyze_if_blob(object)
    return unless object.is_a? ActiveStorage::Blob
    begin
      object.analyze unless object.analyzed?
    rescue
      # https://github.com/osunyorg/admin/issues/1669
      puts "Blob #{object} crashed during analysis"
    end
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
