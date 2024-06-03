class Communication::Website::UpdateThemeVersionJob < Communication::Website::BaseJob
  queue_as :mice

  def execute
    website.update_theme_version_safely
  end
end