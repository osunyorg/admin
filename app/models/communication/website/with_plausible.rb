module Communication::Website::WithPlausible
  extend ActiveSupport::Concern

  def has_plausible?
    plausible_url.present?
  end

  # https://plausible.io/share/osuny.org?auth=[FILTERED] => osuny.org
  def plausible_site_domain
    return unless has_plausible?
    uri = URI.parse(plausible_url)
    uri.path.delete_prefix("/share/")
  rescue URI::InvalidURIError
    nil
  end
end
