module Communication::Website::WithPlausible
  extend ActiveSupport::Concern

  included do
    attr_accessor :should_setup_plausible

    after_save :plausible_setup, if: -> { should_setup_plausible == "1" && !has_plausible? }
  end

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

  def plausible_setup
    Communication::Website::Plausible::SetupJob.perform_later(id)
    @should_setup_plausible = nil
  end

  def plausible_setup_safely
    plausible_site_id = URI.parse(url).host
    plausible_site_id = plausible_site_id.delete_prefix("www.") if plausible_site_id.start_with?("www.")
    plausible_site = plausible.create_site(plausible_site_id)
    plausible_shared_link = plausible.create_shared_link(plausible_site["id"], "Osuny")
    update(plausible_url: plausible_shared_link["url"])
  end

  def plausible
    @plausible ||= Plausible.new
  end
end
