class Communication::Website::UpdateThemeVersionJob < Communication::Website::BaseJob
  def execute
    website.update_theme_version_safely
  end
end