module Communication::Website::WithStatusBadge
  extend ActiveSupport::Concern

  def status_badge?
    kelmscott_active? || deployment_status_badge.present?
  end

  def status_badge_url
    kelmscott_active? ? kelmscott_badge_url : deployment_status_badge
  end
end
