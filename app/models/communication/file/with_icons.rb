module Communication::File::WithIcons
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
  end

  class_methods do
    def icon_for(content_type)
      FILE_TYPES.each_value do |file_type|
        return file_type[:icon] if content_type.in?(file_type[:content_types])
      end
      GENERIC_FILE_TYPE_ICON
    end
  end
end
