module Communication::Extranet::WithLegal
  extend ActiveSupport::Concern

  include ActionView::Helpers::SanitizeHelper

  def has_terms_in?(language)
    l10n = localization_for(language)
    l10n.present? && strip_tags(l10n.terms).to_s.strip.present?
  end

  def has_cookies_policy_in?(language)
    l10n = localization_for(language)
    l10n.present? && strip_tags(l10n.cookies_policy).to_s.strip.present?
  end

  def has_privacy_policy_in?(language)
    l10n = localization_for(language)
    l10n.present? && strip_tags(l10n.privacy_policy).to_s.strip.present?
  end
end
