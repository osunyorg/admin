# == Schema Information
#
# Table name: communication_website_git_files
#
#  id                :uuid             not null, primary key
#  about_type        :string           not null, indexed => [about_id]
#  current_content   :text
#  current_path      :string
#  current_sha       :string
#  desynchronized    :boolean          default(TRUE)
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

  belongs_to :website, class_name: 'Communication::Website'
  belongs_to :about, polymorphic: true

  scope :desynchronized, -> { where(desynchronized: true) }
  scope :desynchronized_since, -> (time) { desynchronized.where('desynchronized_at > ?', time) }
  scope :ordered, -> { order("communication_website_git_files.desynchronized_at DESC NULLS LAST, communication_website_git_files.updated_at DESC") }

  before_create :set_desynchronized_at

  def self.generate(website, about)
    # All exportable objects must respond to this method
    # HasGitFiles defines it
    # AsIndirectObject does not include it, but some indirect objects have it (Person l10n, Organization l10n...)
    # Some objects need to declare that property:
    # - the website itself
    # - configs (which inherit from the website)
    # - active storage blobs
    return unless about.try(:exportable_to_git?)
    # Permalinks must be calculated BEFORE renders
    manage_permalink about, website
    # Blobs need to be completely analyzed, which is async
    analyze_if_blob about
    # The git file might exist or not
    git_file = where(website: website, about: about).first_or_initialize
    git_file.analyze!
  end

  # 3 cases:
  # - it's not there, and should not be there
  # - it's not there, and should be
  # - it's there, and should not be
  def analyze!
    if about.try(:syncable?)
      # If it's just initialized, it needs to be saved
      save unless persisted?
      # Anyway, we need to generate content
      generate_content
    elsif persisted?
      # There, but not syncable, so bye bye
      mark_for_destruction!
    end
  end

  def mark_for_destruction!
    return if current_path.nil? && current_sha.nil?
    update(
      current_path: nil, 
      current_sha: nil,
      desynchronized: true,
      desynchronized_at: Time.zone.now
    )
  end

  def generate_content_safely
    return if path_up_to_date? && content_up_to_date?
    update(
      current_content: computed_content,
      current_path: computed_path,
      current_sha: computed_sha,
      desynchronized: true,
      desynchronized_at: Time.zone.now
    )
  end

  def computed_path
    @computed_path ||= needs_deletion? ? nil : about.git_path(website)&.gsub(/\/+/, '/')
  end

  def needs_deletion?
    about.nil? || !about.try(:syncable?)
  end

  def computed_filename
    @computed_filename ||= File.basename(computed_path)
  end

  def computed_content
    @computed_content ||= Static.render(template_static, about, website)
  end

  def computed_sha
    website.git_repository.computed_sha(computed_content)
  end

  def content_up_to_date?
    current_content == computed_content
  end

  def path_up_to_date?
    current_path == previous_path
  end

  def synchronized?
    !desynchronized
  end

  def mark_as_synced!
    update(
      previous_path: current_path,
      previous_sha: current_sha,
      desynchronized: false,
      desynchronized_at: nil
    )
  end

  def to_s
    current_path.nil? ? 'Nil' : "#{current_path}"
  end

  protected

  def generate_content
    Communication::Website::GitFile::GenerateContentJob.perform_later(self)
  end

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

  def set_desynchronized_at
    self.desynchronized_at = Time.now
  end
end
