class Api::CreateFeaturedMediaFromUrlJob < ApplicationJob
  queue_as :mice

  def perform(object, media_url)
    # Do not attempt to add a media to soft-deleted records
    return if object.paranoid? && object.deleted?

    media_uri = begin
      escaped_url = URI::Parser.new.escape(media_url)
      URI.parse(escaped_url)
    rescue URI::InvalidURIError, ArgumentError
      raise ActionController::BadRequest.new("Invalid featured media URL: #{media_url}")
    end

    return unless media_uri.is_a?(URI::HTTP)
    media = Communication::Media.find_or_create_from_url(media_url, university_id: object.university_id)
    return if media.nil?
    object.featured_media = media
    object.save
    media.add_context(object)
  end
end
