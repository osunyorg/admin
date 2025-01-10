module Communication::Website::Page::WithOpenApi
  extend ActiveSupport::Concern

  included do
    OPENAPI_SCHEMA = {
      type: :object,
      title: "Communication::Website::Page",
      properties: {
        id: { type: :string, format: :uuid },
        migration_identifier: { type: :string, nullable: true },
        type: { type: :string, nullable: true, description: "Read-only. It is set when it's a special page." },
        parent_id: { type: :string, format: :uuid, nullable: true },
        position: { type: :integer },
        bodyclass: { type: :string, nullable: true },
        full_width: { type: :boolean },
        localizations: {
          type: :object,
          description: "Localizations of the page. The key is the language's ISO 639-1 code.",
          additionalProperties: {
            "$ref": "#/components/schemas/communication_website_page_localization"
          }
        },
        category_ids: {
          type: :array,
          items: { type: :string, format: :uuid }
        },
        created_at: { type: :string, format: "date-time" },
        updated_at: { type: :string, format: "date-time" }
      }
    }
  end
end