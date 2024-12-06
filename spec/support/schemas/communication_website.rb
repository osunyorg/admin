module Schemas
  class CommunicationWebsite
    def self.schema
      {
        type: :object,
        title: "Communication::Website",
        properties: {
          id: { type: :string },
          url: { type: :string, nullable: true },
          deuxfleurs: {
            type: :object,
            properties: {
              hosting: { type: :boolean },
              identifier: { type: :string, nullable: true }
            }
          },
          features: {
            type: :object,
            properties: {
              agenda: { type: :boolean },
              portfolio: { type: :boolean },
              posts: { type: :boolean }
            }
          },
          git: {
            type: :object,
            properties: {
              branch: { type: :string, nullable: true },
              endpoint: { type: :string, nullable: true },
              provider: { type: :string, nullable: true },
              repository: { type: :string, nullable: true }
            }
          },
          showcase: {
            type: :object,
            properties: {
              present: { type: :boolean },
              highlighted: { type: :boolean },
              tags: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    id: { type: :string },
                    name: { type: :string },
                    slug: { type: :string }
                  }
                }
              }
            }
          },
          localizations: {
            type: :object,
            description: "Localizations of the website. The key is the language's ISO 639-1 code.",
            additionalProperties: {
              "$ref": "#/components/schemas/communication_website_localization"
            },
            minProperties: 1
          },
          created_at: { type: :string, format: "date-time" },
          updated_at: { type: :string, format: "date-time" }
        }
      }
    end
  end
end