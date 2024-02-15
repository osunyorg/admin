module Communication::Website::WithScreenshot
  extend ActiveSupport::Concern
  
  included do
    has_one_attached :screenshot
  end
  
  def screenshot!
    return if url.blank?
    screenshot_url = Screenshot.capture(url)
    return if screenshot_url.blank?
    downloaded_image = URI.open(screenshot_url)
    self.screenshot.attach  io: downloaded_image, 
                            filename: "screenshot.png"
  end
end