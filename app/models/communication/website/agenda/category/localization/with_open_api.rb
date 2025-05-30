module Communication::Website::Agenda::Category::Localization::WithOpenApi
  extend ActiveSupport::Concern

  included do
    OPENAPI_SCHEMA = {
      type: :object,
      title: "Communication::Website::Agenda::Category::Localization",
      properties: {
        id: { type: :string, format: :uuid },
        migration_identifier: { type: :string, nullable: true },
        name: { type: :string },
        featured_image: {
          type: :object,
          properties: {
            blob_id: { type: :string, format: :uuid, nullable: true },
            alt: { type: :string, nullable: true },
            credit: { type: :string, nullable: true },
            url: { type: :string, nullable: true }
          }
        },
        meta_description: { type: :string, nullable: true },
        path: { type: :string, nullable: true },
        slug: { type: :string },
        summary: { type: :string, nullable: true },
        blocks: {
          type: :array,
          items: {
            oneOf: Communication::Block.templates_openapi_schema_references
          }
        },
        created_at: { type: :string, format: "date-time" },
        updated_at: { type: :string, format: "date-time" }
      }
    }
  end
end