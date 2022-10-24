module Communication::Extranet::WithLegal
  extend ActiveSupport::Concern

  included do
    include ActionView::Helpers::SanitizeHelper
  end

  def has_terms?
    strip_tags(terms).strip.present?
  end

  def has_cookies_policy?
    strip_tags(cookies_policy).strip.present?
  end

  def has_privacy_policy?
    strip_tags(privacy_policy).strip.present?
  end
end
