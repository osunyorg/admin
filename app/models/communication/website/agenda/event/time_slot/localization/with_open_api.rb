module Communication::Website::Agenda::Event::TimeSlot::Localization::WithOpenApi
  extend ActiveSupport::Concern

  included do
    OPENAPI_SCHEMA = {
      type: :object,
      title: "Communication::Website::Agenda::Event::TimeSlot::Localization",
      properties: {
        id: { type: :string, format: :uuid },
        migration_identifier: { type: :string, nullable: true },
        place: { type: :string, nullable: true },
        slug: { type: :string, description: "Read-only, slug is force-generated." },
        add_to_calendar_urls: {
          type: :object,
          properties: {
            google: { type: :string },
            yahoo: { type: :string },
            office: { type: :string },
            outlook: { type: :string },
            ical: { type: :string }
          },
          nullable: true
        },
        created_at: { type: :string, format: "date-time" },
        updated_at: { type: :string, format: "date-time" }
      }
    }
  end
end
