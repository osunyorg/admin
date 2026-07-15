# == Schema Information
#
# Table name: communication_website_git_files
#
#  id                :uuid             not null, primary key, indexed => [website_id]
#  about_type        :string           indexed => [about_id], uniquely indexed => [website_id, about_id]
#  current_path      :string
#  current_sha       :string
#  desynchronized    :boolean          default(TRUE)
#  desynchronized_at :datetime         indexed
#  generated_at      :datetime
#  previous_path     :string
#  previous_sha      :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  about_id          :uuid             indexed => [about_type], uniquely indexed => [website_id, about_type]
#  university_id     :uuid             indexed
#  website_id        :uuid             not null, indexed => [id], uniquely indexed => [about_type, about_id]
#
# Indexes
#
#  index_communication_website_git_files_on_desynchronized_at  (desynchronized_at)
#  index_communication_website_git_files_on_university_id      (university_id)
#  index_communication_website_git_files_on_website_id_and_id  (website_id,id)
#  index_communication_website_github_files_on_about           (about_type,about_id)
#  index_git_files_unique_about_per_website                    (website_id,about_type,about_id) UNIQUE WHERE (about_id IS NOT NULL)
#
# Foreign Keys
#
#  fk_rails_8505d649e8  (website_id => communication_websites.id)
#  fk_rails_b163dea854  (university_id => universities.id)
#
class Communication::Website::GitFile < ApplicationRecord
  # We don't include Sanitizable as this model is never handled by users directly.

  include WithContent

  belongs_to :university
  belongs_to :website, class_name: 'Communication::Website'
  belongs_to :about, polymorphic: true, optional: true

  # One Git File per about and website, unless about is nil (destroy orphans)
  validates :about_id, uniqueness: { scope: [:about_type, :website_id] }, allow_nil: true

  scope :generated, -> { where.not(generated_at: nil) }
  scope :desynchronized, -> { where(desynchronized: true) }
  scope :desynchronized_since, -> (time) { desynchronized.where('desynchronized_at > ?', time) }
  scope :desynchronized_until, -> (time) { desynchronized.where('desynchronized_at <= ?', time) }
  scope :ordered, -> { order("communication_website_git_files.desynchronized_at DESC NULLS LAST, communication_website_git_files.updated_at DESC") }

  before_create :set_desynchronized_at

  def self.generate(website, about)
    # Do nothing about nil...
    return if about.nil?
    # Blobs need to be completely analyzed, which is async
    analyze_if_blob about
    # The git file might exist or not
    scope = where(university: website.university, website: website, about: about)
    scope.first_or_initialize.analyze!
  rescue ActiveRecord::RecordNotUnique
    # A concurrent job created the row between our validation and our INSERT:
    # the unique index rejected it, so we fetch the existing one and analyze it.
    scope.first&.analyze!
  end

  # 3 cases:
  # - it's not there, and should not be there
  # - it's not there, and should be
  # - it's there, and should not be
  def analyze!
    if should_generate_content?
      # If it's just initialized, it needs to be saved
      save unless persisted?
      # Anyway, we need to generate content (from WithContent)
      generate_content if valid?
    elsif persisted?
      # There, but not syncable, so bye bye
      mark_for_destruction!
    end
  end

  def mark_for_update!
    update(
      desynchronized: true,
      desynchronized_at: Time.zone.now
    )
  end

  def mark_for_destruction!
    return if current_path.nil? && current_sha.nil?
    now = Time.zone.now
    update(
      current_path: nil,
      current_sha: nil,
      desynchronized: true,
      desynchronized_at: now,
      generated_at: now
    )
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

  def generated?
    generated_at.present?
  end

  def to_s
    current_path.presence || (previous_path.present? ? "Delete #{previous_path}" : "No path")
  end

  protected

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

  def should_generate_content?
    about.try(:can_have_git_file?) &&
    about.try(:should_sync_to?, website)
  end

  # Real sha on the git repo
  def git_sha_for(path)
    website.git_repository.git_sha path
  end

  def git_sha
    @git_sha ||= git_sha_for(path)
  end

  def set_desynchronized_at
    self.desynchronized_at = Time.now
  end
end
