# == Schema Information
#
# Table name: communication_file_localizations
#
#  id                    :uuid             not null, primary key
#  internal_description  :text
#  meta_description      :text
#  name                  :string
#  original_byte_size    :bigint
#  original_checksum     :string
#  original_content_type :string
#  original_extension    :string           default("")
#  original_filename     :string
#  published             :boolean          default(FALSE)
#  published_at          :datetime
#  slug                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  about_id              :uuid             not null, indexed
#  language_id           :uuid             not null, indexed
#  last_updated_by_id    :uuid             indexed
#  original_blob_id      :uuid             not null, indexed
#  published_by_id       :uuid             indexed
#  university_id         :uuid             not null, indexed
#
# Indexes
#
#  index_communication_file_localizations_on_about_id            (about_id)
#  index_communication_file_localizations_on_language_id         (language_id)
#  index_communication_file_localizations_on_last_updated_by_id  (last_updated_by_id)
#  index_communication_file_localizations_on_original_blob_id    (original_blob_id)
#  index_communication_file_localizations_on_published_by_id     (published_by_id)
#  index_communication_file_localizations_on_university_id       (university_id)
#
# Foreign Keys
#
#  fk_rails_2caf77cf04  (original_blob_id => active_storage_blobs.id)
#  fk_rails_38de4b5d8a  (language_id => languages.id)
#  fk_rails_6f750651f5  (about_id => communication_files.id)
#  fk_rails_ad6002e199  (last_updated_by_id => users.id)
#  fk_rails_beb53a5697  (published_by_id => users.id)
#  fk_rails_fcfa27eb47  (university_id => universities.id)
#
class Communication::File::Localization < ApplicationRecord
  include AsLocalization
  include HasGitFiles
  include HasOriginalBlob
  include HasUniversity
  include Permalinkable
  include Sanitizable
  include WithOpenApi

  belongs_to  :last_updated_by,
              class_name: 'User',
              optional: true

  has_many    :contexts,
              foreign_key: :communication_file_localization_id,
              dependent: :destroy
  alias :file :about

  before_create :guess_name_from_file
  after_commit :touch_references, on: :update, if: :saved_change_to_original_blob_id

  def self.find_or_create_from_blob(blob, language, user)
    localization = where(
      university_id: blob.university_id,
      language_id: language.id,
      original_checksum: blob.checksum
    ).first_or_create do |localization|
      file = Communication::File.find_or_create_from_blob(blob, user)
      # On attribue le blob
      localization.original_blob = blob
      # On connecte au fichier
      localization.about_id = file.id
    end
    localization
  end

  def git_path_relative
    "files/#{created_at.year}/#{slug}.html"
  end

  def should_sync_to?(website)
    website.active_language_ids.include?(language_id) &&
    website.has_connected_object?(self)
  end

  def template_static
    "admin/communication/library/files/static"
  end

  def max_file_size
    Rails.application.config.default_file_max_size
  end

  def icon
    @icon ||= Communication::File.icon_for(original_content_type)
  end

  # 'Image (image/jpeg)', ou juste 'image/jpeg' si le type est inconnu
  def human_content_type
    human_filetype = Communication::File.human_filetype_for(original_content_type)
    human_filetype ? "#{human_filetype} (#{original_content_type})" : original_content_type
  end

  def dependencies
    [original_blob]
  end

  def references
    contexts.map(&:about)
  end

  def to_s
    "#{name}"
  end

  protected

  def guess_name_from_file
    filename = original_blob.filename
    filename_without_extension = File.basename(filename, File.extname(filename))
    self.name = filename_without_extension.humanize
  end
end
