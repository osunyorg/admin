module Schemas
  class CommunicationWebsitePostLocalization
    def self.schema
      {
        type: :object,
        title: "Communication::Website::Post::Localization",
        properties: {
          id: { type: :string },
          migration_identifier: { type: :string, nullable: true },
          title: { type: :string },
          featured_image: {
            type: :object,
            properties: {
              blob_id: { type: :string, nullable: true },
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
          text: { type: :string, nullable: true },
          blocks: {
            type: :array,
            items: {
              "$ref": "#/components/schemas/communication_block"
            }
          }
        }
      }
    end
  end
end