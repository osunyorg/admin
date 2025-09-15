module Communication::Website::WithProduction
  extend ActiveSupport::Concern

  included do
    before_validation :set_in_production_at

    scope :in_production, -> { where(in_production: true) }
    scope :for_production, -> (production, language = nil) { where(in_production: production) }
    scope :ordered_by_production_date, -> {
      in_production.order(in_production_at: :desc)
    }
  end

  protected

  def set_in_production_at
    self.in_production_at = Time.zone.now if in_production && in_production_at.nil?
  end
end
