module Communication::Extranet::WithLegal
  extend ActiveSupport::Concern

  include ActionView::Helpers::SanitizeHelper

  def has_terms?
    strip_tags(terms).to_s.strip.present?
  end

  def has_cookies_policy?
    strip_tags(cookies_policy).to_s.strip.present?
  end

  def has_privacy_policy?
    strip_tags(privacy_policy).to_s.strip.present?
  end
end
