module HasFeaturedMedia
  extend ActiveSupport::Concern

  included do
    attr_accessor :featured_media_new_url

    belongs_to  :featured_media,
                class_name: 'Communication::Media',
                optional: true

    after_commit :create_featured_media_from_url_later, on: [:create, :update]
  end

  # Can be overwrite to get featured media from associated objects (ex: parents)
  def best_featured_media_source(fallback: true)
    self
  end

  def best_featured_media
    best_featured_media_source.featured_media
  end

  def best_featured_media_alt
    best_featured_media_source.featured_media_alt
  end

  def best_featured_media_credit
    best_featured_media_source.featured_media_credit
  end

  # Credit is not localized on the object, it belongs to the media itself
  def featured_media_credit
    featured_media_localization&.credit
  end

  def featured_blob
    featured_media&.original_blob
  end

  def best_featured_blob
    best_featured_media&.original_blob
  end

  def featured_media_localization
    return if featured_media.nil?
    featured_media.best_localization_for(language)
  end

  protected

  def create_featured_media_from_url_later
    # No image to upload
    return unless featured_media_new_url.present?
    # Image already uploaded
    return if featured_blob&.metadata&.dig(:source_url) == featured_media_new_url
    # Else, delay the upload
    Api::CreateFeaturedMediaFromUrlJob.perform_later(self, featured_media_new_url)
  ensure
    self.featured_media_new_url = nil
  end
end
