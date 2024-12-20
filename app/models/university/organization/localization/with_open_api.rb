module University::Organization::Localization::WithOpenApi
  extend ActiveSupport::Concern

  included do
    OPENAPI_SCHEMA = {
      type: :object,
      title: "University::Organization::Localization",
      properties: {
        id: { type: :string, format: :uuid },
        migration_identifier: { type: :string, nullable: true },
        name: { type: :string },
        long_name: { type: :string, nullable: true },
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
        address_name: { type: :string, nullable: true },
        address_additional: { type: :string, nullable: true },
        linkedin: { type: :string, nullable: true },
        mastodon: { type: :string, nullable: true },
        twitter: { type: :string, nullable: true },
        url: { type: :string, nullable: true },
        slug: { type: :string, nullable: true },
        summary: { type: :string, nullable: true },
        text: { type: :string, nullable: true },
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
