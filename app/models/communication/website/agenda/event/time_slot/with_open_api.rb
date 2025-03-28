module Communication::Website::Agenda::Event::TimeSlot::WithOpenApi
  extend ActiveSupport::Concern

  included do
    OPENAPI_SCHEMA = {
      type: :object,
      title: "Communication::Website::Agenda::Event::TimeSlot",
      properties: {
        id: { type: :string, format: :uuid },
        migration_identifier: { type: :string, nullable: true },
        datetime: { type: :string, format: "date-time" },
        duration: { type: :integer, description: "Duration of the time slot (in seconds)." },
        localizations: {
          type: :object,
          description: "Localizations of the time slot. The key is the language's ISO 639-1 code.",
          additionalProperties: {
            "$ref": "#/components/schemas/communication_website_agenda_event_time_slot_localization"
          }
        },
        created_at: { type: :string, format: "date-time" },
        updated_at: { type: :string, format: "date-time" }
      }
    }
  end
end
