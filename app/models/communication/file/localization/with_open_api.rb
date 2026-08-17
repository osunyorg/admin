module Communication::File::Localization::WithOpenApi
  extend ActiveSupport::Concern

  included do
    OPENAPI_SCHEMA = {
      type: :object,
      title: "Communication::File::Localization",
      properties: {
        id: { type: :string, format: :uuid, nullable: true },
        name: { type: :string, nullable: true },
        slug: { type: :string, nullable: true },
        internal_description: { type: :string, nullable: true },
        original_byte_size: { type: :string, nullable: true },
        original_checksum: { type: :string, nullable: true },
        original_content_type: { type: :string, nullable: true },
        original_filename: { type: :string, nullable: true },
        original_blob: {
          type: :object,
          properties: {
            id: { type: :string, format: :uuid, nullable: true },
            signed_id: { type: :string, nullable: true },
            filename: { type: :string, nullable: true },
            content_type: { type: :string, nullable: true }
          },
          nullable: true
        },
        created_at: { type: :string, format: "date-time" },
        updated_at: { type: :string, format: "date-time" }
      }
    }
  end
end