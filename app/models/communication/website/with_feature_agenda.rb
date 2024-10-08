module Communication::Website::WithFeatureAgenda
  extend ActiveSupport::Concern

  included do
    has_many    :agenda_events,
                class_name: "Communication::Website::Agenda::Event",
                foreign_key: :communication_website_id,
                dependent: :destroy
    alias       :events :agenda_events

    has_many    :agenda_categories,
                class_name: 'Communication::Website::Agenda::Category',
                foreign_key: :communication_website_id,
                dependent: :destroy

    scope :with_feature_agenda, -> { where(feature_agenda: true) }
  end

  def has_agenda_events?
    agenda_events.published.any?
  end

  def has_agenda_categories?
    agenda_categories.any?
  end
end