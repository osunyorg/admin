module Communication::Website::WithTheme
  extend ActiveSupport::Concern

  def get_current_theme_version!
    self.update_column :theme_version, current_theme_version
  end

  def theme_version_url
    return if url.blank?
    "#{url}/osuny-theme-version"
  end

  protected

  def current_theme_version
    URI(theme_version_url).read
  rescue
    'NA'
  end
end