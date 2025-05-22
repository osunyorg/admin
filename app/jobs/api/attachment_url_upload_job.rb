class Api::AttachmentUrlUploadJob < ApplicationJob
  discard_on ActiveJob::DeserializationError

  def perform(object, attachment_name, attachment_url)
    attachment_uri = begin
      URI.parse(attachment_url)
    rescue URI::InvalidURIError
      raise ActionController::BadRequest.new("Invalid featured image URL: #{featured_image_url}")
    end

    return unless attachment_uri.is_a?(URI::HTTP)
    object.public_send(attachment_name).attach(
      io: attachment_uri.open,
      filename: File.basename(attachment_uri.path),
      metadata: { source_url: attachment_url }
    )
    object.save
  end
end