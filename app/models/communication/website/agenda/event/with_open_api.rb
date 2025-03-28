module Communication::Website::Agenda::Event::WithOpenApi
  extend ActiveSupport::Concern

  included do
    OPENAPI_SCHEMA = {
      type: :object,
      title: "Communication::Website::Agenda::Event",
      properties: {
        id: { type: :string, format: :uuid },
        migration_identifier: { type: :string, nullable: true },
        from_day: { type: :string, format: "date" },
        to_day: { type: :string, format: "date" },
        time_zone: { type: :string },
        created_by_id: { type: :string, format: :uuid, nullable: true },
        parent_id: { type: :string, format: :uuid, nullable: true },
        localizations: {
          type: :object,
          description: "Localizations of the event. The key is the language's ISO 639-1 code.",
          additionalProperties: {
            "$ref": "#/components/schemas/communication_website_agenda_event_localization"
          }
        },
        time_slots: {
          type: :array,
          items: {
            "$ref": "#/components/schemas/communication_website_agenda_event_time_slot"
          }
        },
        created_at: { type: :string, format: "date-time" },
        updated_at: { type: :string, format: "date-time" }
      }
    }
  end
end
