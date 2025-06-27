module Communication::Media::WithOpenApi
  extend ActiveSupport::Concern

  included do
    OPENAPI_SCHEMA = {
      type: :object,
      title: "Communication::Media",
      properties: {
        id: { type: :string, format: :uuid, nullable: true },
        origin: { type: :string, enum: Communication::Media.origins.keys, nullable: false },
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
        localizations: {
          type: :object,
          description: "Localizations of the media. The key is the language's ISO 639-1 code.",
          additionalProperties: {
            "$ref": "#/components/schemas/communication_media_localization"
          }
        },
        communication_media_collection_id: { type: :string, format: :uuid, nullable: true },
        created_at: { type: :string, format: "date-time" },
        updated_at: { type: :string, format: "date-time" }
      }
    }
  end
end