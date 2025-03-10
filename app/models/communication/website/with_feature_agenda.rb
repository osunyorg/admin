module Communication::Website::WithFeatureAgenda
  extend ActiveSupport::Concern

  included do
    has_many    :agenda_events,
                class_name: "Communication::Website::Agenda::Event",
                foreign_key: :communication_website_id,
                dependent: :destroy
    alias       :events :agenda_events

    has_many    :agenda_events_time_slots,
                class_name: "Communication::Website::Agenda::Event::TimeSlot",
                foreign_key: :communication_website_id,
                dependent: :destroy
    alias       :time_slots :agenda_events_time_slots

    has_many    :agenda_exhibitions,
                class_name: "Communication::Website::Agenda::Exhibition",
                foreign_key: :communication_website_id,
                dependent: :destroy
    alias       :exhibitions :agenda_exhibitions

    has_many    :agenda_categories,
                class_name: 'Communication::Website::Agenda::Category',
                foreign_key: :communication_website_id,
                dependent: :destroy

    has_many    :agenda_period_years,
                class_name: 'Communication::Website::Agenda::Period::Year',
                foreign_key: :communication_website_id,
                dependent: :destroy
    alias       :agenda_years :agenda_period_years

    has_many    :agenda_period_months,
                class_name: 'Communication::Website::Agenda::Period::Month',
                foreign_key: :communication_website_id,
                dependent: :destroy
    alias       :agenda_months :agenda_period_months

    scope :with_feature_agenda, -> { where(feature_agenda: true) }
  end

  def feature_agenda_name(language)
    begin
      special_page(Communication::Website::Page::CommunicationAgenda).best_localization_for(language)
    rescue
      Communication::Website::Agenda::Event.model_name.human(count: 2)
    end
  end

  def feature_agenda_dependencies
    events +
    exhibitions +
    agenda_categories +
    agenda_years +
    agenda_months
  end
end