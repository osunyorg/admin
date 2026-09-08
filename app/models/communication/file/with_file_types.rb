module Communication::File::WithFileTypes
  extend ActiveSupport::Concern

  included do
    FILE_TYPES = {
      archive: {
        icon: 'bi bi-file-earmark-zip',
        content_types: [
          'application/gzip',
          'application/x-gzip',
          'application/zip',
          'application/x-zip-compressed',
          'application/x-7z-compressed',
        ]
      },
      audio: {
        icon: 'bi bi-file-earmark-music',
        content_types: [
          'audio/aac',
          'audio/mpeg',
          'audio/ogg',
          'audio/wav',
          'audio/webm',
        ]
      },
      text: {
        icon: 'bi bi-file-text',
        content_types: [
          'application/msword',
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
          'text/markdown',
          'text/plain',
          'application/vnd.oasis.opendocument.text'
        ]
      },
      image: {
        icon: 'bi bi-file-earmark-image',
        content_types: [
          'image/jpeg',
          'image/png',
          'image/svg+xml',
          'image/tiff',
        ]
      },
      pdf: {
        icon: 'bi bi-file-earmark-pdf',
        content_types: [
          'application/pdf',
        ]
      },
      presentation: {
        icon: 'bi bi-file-slides',
        content_types: [
          'application/vnd.oasis.opendocument.presentation',
          'application/vnd.ms-powerpoint',
          'application/vnd.openxmlformats-officedocument.presentationml.presentation',
        ]
      },
      spreadsheet: {
        icon: 'bi bi-file-spreadsheet',
        content_types: [
          'application/vnd.oasis.opendocument.spreadsheet',
          'application/vnd.ms-excel',
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        ]
      },
      video: {
        icon: 'bi bi-file-earmark-play',
        content_types: [
          'video/x-msvideo',
          'video/mp4',
          'video/mpeg',
          'video/ogg',
          'video/webm',
        ]
      },
    }

    GENERIC_FILE_TYPE_ICON = 'bi bi-file-earmark'

    scope :for_filetype, -> (filetypes, language) {
      with_localizations(language)
      .where(communication_file_localizations: {
        original_content_type: content_types_for(filetypes)
      })
    }
  end

  class_methods do
    def icon_for(content_type)
      FILE_TYPES.each_value do |file_type|
        return file_type[:icon] if content_type.in?(file_type[:content_types])
      end
      GENERIC_FILE_TYPE_ICON
    end

    # 'application/pdf' => :pdf
    def filetype_for(content_type)
      FILE_TYPES.find { |_filetype, data|
        content_type.in?(data[:content_types])
      }&.first
    end

    # 'image/jpeg' => 'Image'
    def human_filetype_for(content_type)
      filetype = filetype_for(content_type)
      return if filetype.nil?
      I18n.t("admin.communication.file_types.#{filetype}")
    end

    # [:pdf, :image] => ['application/pdf', 'image/jpeg', ...]
    def content_types_for(filetypes)
      Array(filetypes).flat_map { |filetype|
        FILE_TYPES.dig(filetype.to_sym, :content_types)
      }.compact
    end

    # Récupère seulement les types de fichiers vraiment présents dans la liste
    def filetypes_present_in(files)
      FILE_TYPES.keys.select do |filetype|
        all_content_types_for_filetype = content_types_for(filetype)
        present_content_types = content_types_present_in(files)
        intersected = all_content_types_for_filetype & present_content_types
        intersected.any?
      end
    end

    def content_types_present_in(files)
      files.joins(:localizations)
           .distinct
           .pluck(:original_content_type)
           .compact
    end
  end
end
