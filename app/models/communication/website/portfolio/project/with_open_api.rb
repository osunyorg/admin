module Communication::Website::Portfolio::Project::WithOpenApi
  extend ActiveSupport::Concern

  included do
    OPENAPI_SCHEMA = {
      type: :object,
      title: "Communication::Website::Portfolio::Project",
      properties: {
        id: { type: :string, format: :uuid },
        migration_identifier: { type: :string, nullable: true },
        full_width: { type: :boolean },
        bodyclass: { type: :string, nullable: true },
        year: { type: :integer },
        localizations: {
          type: :object,
          description: "Localizations of the project. The key is the language's ISO 639-1 code.",
          additionalProperties: {
            "$ref": "#/components/schemas/communication_website_portfolio_project_localization"
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
