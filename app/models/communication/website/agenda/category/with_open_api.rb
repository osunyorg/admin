module Communication::Website::Agenda::Category::WithOpenApi
  extend ActiveSupport::Concern

  included do
    OPENAPI_SCHEMA = {
      type: :object,
      title: "Communication::Website::Agenda::Category",
      properties: {
        id: { type: :string, format: :uuid },
        migration_identifier: { type: :string, nullable: true },
        parent_id: { type: :string, format: :uuid, nullable: true },
        position: { type: :integer },
        is_taxonomy: { type: :boolean },
        localizations: {
          type: :object,
          description: "Localizations of the category. The key is the language's ISO 639-1 code.",
          additionalProperties: {
            "$ref": "#/components/schemas/communication_website_agenda_category_localization"
          }
        },
        created_at: { type: :string, format: "date-time" },
        updated_at: { type: :string, format: "date-time" }
      }
    }
  end
end