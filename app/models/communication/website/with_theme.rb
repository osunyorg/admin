module Communication::Website::WithTheme
  extend ActiveSupport::Concern
  
  included do
    scope :with_automatic_update, -> { where(autoupdate_theme: true) }
    scope :with_manual_update, -> { where(autoupdate_theme: false) }

    def self.autoupdate_websites
      Communication::Website.with_automatic_update.find_each do |website|
        website.update_theme_version
      end
    end
  end

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