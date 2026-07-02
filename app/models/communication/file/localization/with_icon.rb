module Communication::File::Localization::WithIcon
  extend ActiveSupport::Concern

  FILE_TYPES = [
    {
      # Archive compressée
      icon: 'bi bi-file-earmark-zip',
      content_types: [
        'application/gzip',
        'application/x-gzip',
        'application/zip',
        'application/x-zip-compressed',
        'application/x-7z-compressed',
      ]
    },
    {
      # Audio
      icon: 'bi bi-file-earmark-music',
      content_types: [
        'audio/aac',
        'audio/mpeg',
        'audio/ogg',
        'audio/wav',
        'audio/webm',
      ]
    },
    {
      # Document texte
      icon: 'bi bi-file-text',
      content_types: [
        'application/msword',
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        'text/markdown',
        'application/vnd.oasis.opendocument.text'
      ]
    },
    {
      # Image
      icon: 'bi bi-file-earmark-image',
      content_types: [
        'image/jpeg',
        'image/png',
        'image/svg+xml',
        'image/tiff',
      ]
    },
    {
      # PDF
      icon: 'bi bi-file-earmark-pdf',
      content_types: [
        'application/pdf',
      ]
    },
    {
      # Présentation
      icon: 'bi bi-file-slides',
      content_types: [
        'application/vnd.oasis.opendocument.presentation',
        'application/vnd.ms-powerpoint',
        'application/vnd.openxmlformats-officedocument.presentationml.presentation',
      ]
    },
    {
      # Tableur
      icon: 'bi bi-file-spreadsheet',
      content_types: [
        'application/vnd.oasis.opendocument.spreadsheet',
        'application/vnd.ms-excel',
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      ]
    },
    {
      # Vidéo
      icon: 'bi bi-file-earmark-play',
      content_types: [
        'video/x-msvideo',
        'video/mp4',
        'video/mpeg',
        'video/ogg',
        'video/webm',
      ]
    },
  ]

  GENERIC_FILE_TYPE = 'bi bi-file-earmark'

  def icon
    FILE_TYPES.each do |file_type|
      return file_type[:icon] if is_current_type?(file_type)
    end
    return GENERIC_FILE_TYPE
  end

  protected

  def is_current_type?(file_type)
    original_content_type.in?(file_type[:content_types])
  end
end