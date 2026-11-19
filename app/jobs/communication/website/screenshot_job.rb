class Communication::Website::ScreenshotJob < Communication::Website::BaseJob
  queue_as :mice

  def execute
    website.screenshot_safely
  end
end
