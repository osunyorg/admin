class Api::AttachFeaturedImageFromUrlJob < ApplicationJob
  queue_as :mice

  def perform(object, attachment_url)
    attachment_uri = begin
      escaped_url = URI::Parser.new.escape(attachment_url)
      URI.parse(escaped_url)
    rescue URI::InvalidURIError, ArgumentError
      raise ActionController::BadRequest.new("Invalid featured image URL: #{attachment_url}")
    end

    return unless attachment_uri.is_a?(URI::HTTP)
    object.featured_image.attach(
      io: attachment_uri.open,
      filename: File.basename(attachment_uri.path),
      metadata: { source_url: attachment_url }
    )
    object.save
  end
end
