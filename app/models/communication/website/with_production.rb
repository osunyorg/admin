module Communication::Website::WithProduction
  extend ActiveSupport::Concern

  included do
    scope :in_production, -> { where(in_production: true) }
    scope :for_production, -> (production, language = nil) { where(in_production: production) }
    scope :ordered_by_production_date, -> {
      in_production.order(in_production_at: :desc)
    }
  end

end
