module WithFeaturedImage
  extend ActiveSupport::Concern

  included do
    attr_accessor :featured_image_new_url

    has_summernote :featured_image_credit
    has_one_attached_deletable :featured_image

    validates :featured_image, size: { less_than: 5.megabytes }

    after_commit :upload_featured_image_later, on: [:create, :update]
  end

  # Can be overwrite to get featured_image from associated objects (ex: parents)
  def best_featured_image_source(fallback: true)
    self
  end

  def best_featured_image
    best_featured_image_source.featured_image
  end

  def best_featured_image_alt
    best_featured_image_source.featured_image_alt
  end

  def best_featured_image_credit
    best_featured_image_source.featured_image_credit
  end

  protected

  def upload_featured_image_later
    # No image to upload
    return unless featured_image_new_url.present?
    # Image already uploaded
    return if featured_image.attached? && featured_image.blob.metadata[:source_url] == featured_image_new_url
    # Else, delay the upload
    Api::AttachFeaturedImageFromUrlJob.perform_later(self, featured_image_new_url)
  ensure
    self.featured_image_new_url = nil
  end
end
