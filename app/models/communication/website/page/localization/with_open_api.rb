module Communication::Website::Page::Localization::WithOpenApi
  extend ActiveSupport::Concern

  included do
    OPENAPI_SCHEMA = {
      type: :object,
      title: "Communication::Website::Page::Localization",
      properties: {
        id: { type: :string, format: :uuid },
        migration_identifier: { type: :string, nullable: true },
        title: { type: :string },
        breadcrumb_title: { type: :string, nullable: true },
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
        published: { type: :boolean },
        published_at: { type: :string, format: 'date-time', nullable: true },
        slug: { type: :string },
        summary: { type: :string, nullable: true },
        text: { type: :string, nullable: true },
        header_text: { type: :string, nullable: true },
        header_cta: { type: :boolean, nullable: true },
        header_cta_label: { type: :string, nullable: true },
        header_cta_url: { type: :string, nullable: true },
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
