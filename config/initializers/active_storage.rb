require 'active_storage/attachment'
require 'active_storage/filename'

ActiveStorage::Engine.config.active_storage.content_types_to_serve_as_binary.delete('image/svg+xml')

# Hook ActiveStorage::Attachment to add brand_id to attachments records
ActiveStorage::Attachment.class_eval do
  after_save :denormalize_university_id_for_blob

  def denormalize_university_id_for_blob
    university_id = case self.record.class.name
    when 'University'
        self.record.id
      when 'ActiveStorage::VariantRecord'
        self.record.blob.university_id
      else
        self.record.university_id
    end

    self.blob.update_column(:university_id, university_id)
  end
end

# Override ActiveStorage::Filename#sanitized to remove accents and all special chars
# Base method: https://github.com/rails/rails/blob/v6.1.3/activestorage/app/models/active_storage/filename.rb#L57
ActiveStorage::Filename.class_eval do
  def sanitized
    base_filename = base.encode(Encoding::UTF_8, invalid: :replace, undef: :replace, replace: "�")
                        .strip
                        .tr("\u{202E}%$|:;/\t\r\n\\", "-")
                        .parameterize(preserve_case: true)
    [base_filename, extension_with_delimiter].join('')
  end
end

# https://stackoverflow.com/questions/8895103/how-can-i-keep-my-initializer-configuration-from-being-lost-in-development-mode
Rails.application.config.to_prepare do
  module ActiveStorageGitPathStatic
    extend ActiveSupport::Concern

    included do
      has_many :git_files, class_name: "Communication::Website::GitFile", as: :about, dependent: :destroy
    end

    def git_path(website)
      "data/media/#{id[0..1]}/#{id}.yml"
    end

    def before_git_sync
      analyze unless analyzed?
    end
  end

  ActiveStorage::Blob.include ActiveStorageGitPathStatic
end
