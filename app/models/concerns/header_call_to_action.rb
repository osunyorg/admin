# frozen_string_literal: true
module HeaderCallToAction
  extend ActiveSupport::Concern

  def header_cta_url_external?(website)
    return false if header_cta_url.blank?
    !header_cta_url_internal?(website)
  end

  def header_cta_url_internal?(website)
    return false if header_cta_url.blank?
    header_cta_url.start_with?('/') || header_cta_url.start_with?(website.url)
  end
end