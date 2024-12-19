module Communication::Website::Post::WithOpenApi
  extend ActiveSupport::Concern

  included do
    OPENAPI_SCHEMA = {
      type: :object,
      title: "Communication::Website::Post",
      properties: {
        id: { type: :string, format: :uuid },
        migration_identifier: { type: :string, nullable: true },
        full_width: { type: :boolean },
        localizations: {
          type: :object,
          description: "Localizations of the post. The key is the language's ISO 639-1 code.",
          additionalProperties: {
            "$ref": "#/components/schemas/communication_website_post_localization"
          }
        },
        created_at: { type: :string, format: "date-time" },
        updated_at: { type: :string, format: "date-time" }
      }
    }
  end
end