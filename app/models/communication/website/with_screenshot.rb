module Communication::Website::WithScreenshot
  extend ActiveSupport::Concern
  
  included do
    has_one_attached :screenshot
  end
  
  def screenshot!
    return if url.blank?
    screenshot_url = Screenshot.capture(url)
    ActiveStorage::Utils.attach_from_url(
      self.screenshot,
      screenshot_url,
      filename: 'screenshot.png'
    )
  end
end