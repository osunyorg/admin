module Communication::Website::WithScreenshot
  extend ActiveSupport::Concern

  included do
    has_one_attached :screenshot
    has_one_attached :screenshot_full_page
  end

  def screenshot!
    return if url.blank?
    make_screenshot!
    make_screenshot!(full_page: true)
  end

  protected

  def make_screenshot!(full_page: false)
    name = full_page ? "screenshot_full_page" : "screenshot"
    screenshot_url = Screenshot.capture(url, full_page: full_page)
    blob = ActiveStorage::Utils.blob_from_url(
      screenshot_url,
      filename: "#{name}.png",
      content_type: 'image/png'
    )
    return if blob.nil?
    attachment_change = ActiveStorage::Attached::Changes::CreateOne.new(name, self, blob)
    attachment_change.save
  end
end
