module Communication::Media::Localization::WithOpenApi
  extend ActiveSupport::Concern

  included do
    OPENAPI_SCHEMA = {
      type: :object,
      title: "Communication::Media::Localization",
      properties: {
        id: { type: :string, format: :uuid, nullable: true },
        name: { type: :string, nullable: true },
        alt: { type: :string, nullable: true },
        credit: { type: :string, nullable: true },
        internal_description: { type: :string, nullable: true },
        created_at: { type: :string, format: "date-time" },
        updated_at: { type: :string, format: "date-time" }
      }
    }
  end
end