module University::Organization::WithOpenApi
  extend ActiveSupport::Concern

  included do
    OPENAPI_SCHEMA = {
      type: :object,
      title: "University::Organization",
      properties: {
        id: { type: :string, format: :uuid },
        migration_identifier: { type: :string, nullable: true },
        kind: { type: :string, enum: University::Organization.kinds.keys },
        active: { type: :boolean },
        email: { type: :string, nullable: true },
        phone: { type: :string, nullable: true },
        address: { type: :string, nullable: true },
        zipcode: { type: :string, nullable: true },
        city: { type: :string, nullable: true },
        country: { type: :string, nullable: true },
        latitude: { type: :number, format: :float, nullable: true },
        longitude: { type: :number, format: :float, nullable: true },
        nic: { type: :string, nullable: true },
        siren: { type: :string, nullable: true },
        localizations: {
          type: :object,
          description: "Localizations of the organization. The key is the language's ISO 639-1 code.",
          additionalProperties: {
            "$ref": "#/components/schemas/university_organization_localization"
          }
        },
        created_at: { type: :string, format: "date-time" },
        updated_at: { type: :string, format: "date-time" }
      }
    }
  end
end
