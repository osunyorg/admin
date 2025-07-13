module University::Organization::WithKind
  extend ActiveSupport::Concern

  included do
    enum :kind, { company: 10, non_profit: 20, government: 30, public_org: 40, collective: 50 }

    scope :for_kind, -> (kind, language = nil) { where(kind: kind) }
  end
end
