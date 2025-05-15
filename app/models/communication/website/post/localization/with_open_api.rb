module Communication::Website::Post::Localization::WithOpenApi
  extend ActiveSupport::Concern

  included do
    OPENAPI_SCHEMA = {
      type: :object,
      title: "Communication::Website::Post::Localization",
      properties: {
        id: { type: :string, format: :uuid },
        migration_identifier: { type: :string, nullable: true },
        title: { type: :string },
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
        pinned: { type: :boolean, nullable: true },
        published: { type: :boolean },
        published_at: { type: :string, format: 'date-time', nullable: true },
        slug: { type: :string },
        subtitle: { type: :string, nullable: true },
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