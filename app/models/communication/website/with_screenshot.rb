module Communication::Website::WithScreenshot
  extend ActiveSupport::Concern

  included do
    has_one_attached :screenshot
  end

  def screenshot!
    return if url.blank?
    screenshot_url = Screenshot.capture(url)
    blob = ActiveStorage::Utils.blob_from_url(
      screenshot_url,
      filename: 'screenshot.png',
      content_type: 'image/png'
    )
    attachment_change = ActiveStorage::Attached::Changes::CreateOne.new("screenshot", self, blob)
    attachment_change.save
  end
end
