module ActiveStorage

  # ActiveStorage::Utils.duplicate(
  #   from.featured_image,
  #   to.featured_image
  # )
  class Utils
    def self.duplicate(from, to)
      return unless from.attached?
      attach_from_url(
        to,
        from.url,
        filename: from.filename.to_s,
        content_type: from.content_type
      )
    end

    # ActiveStorage::Utils.attach_from_url(
    #   featured_image,
    #   'https://.../image.jpg',
    #   filename: 'image.jpg',
    #   content_type: 'image/jpeg'
    # )
    def self.attach_from_url(property, url, filename: nil, content_type: nil)
      return if url.blank?
      url_attachable = UrlAttachable.new(url, filename, content_type)
      return if url_attachable.io.nil?
      property.attach(
        io: url_attachable.io, 
        filename: url_attachable.filename,
        content_type: url_attachable.content_type
      )
    rescue
    end

    def self.attach_from_text(property, text, filename)
      return if text.blank?
      io = StringIO.new text.to_s.force_encoding('UTF-8')
      property.attach(
        io: io, 
        filename: filename,
        content_type: "text/plain; charset=utf-8"
      )
    end

    def self.text_from_attachment(property)
      return '' unless property.attached?
      property.download.force_encoding('UTF-8')
    end
  end

  class UrlAttachable
    attr_reader :url

    def initialize(url, filename = nil, content_type = nil)
      @url = url
      @filename = filename
      @content_type = content_type
    end

    def io
      @io ||= URI.parse(url).open
    rescue
      # URI open can fail
    end

    def filename
      @filename ||= File.basename(url).split('?').first
    end

    def content_type
      @content_type ||= io.content_type
    end
  end
end