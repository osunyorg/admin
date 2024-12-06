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
          text: { type: :string, nullable: true }
          # blocks: {
          #   type: :array,
          #   items: {
          #     type: :object,
          #     properties: {
          #       migration_identifier: { type: :string },
          #       template_kind: { type: :string, description: "Template kind of the blocks. See /communication/blocks/templates for possible values." },
          #       title: { type: :string },
          #       position: { type: :integer },
          #       published: { type: :boolean, default: true },
          #       html_class: { type: :string, description: "For advanced use. Add an HTML class for custom purposes." },
          #       data: {
          #         type: :object,
          #         description: "Data of the block. The structure depends on the template kind.",
          #         additionalProperties: true
          #       }
          #     }
          #   }
          # }
        }
      }
    end
  end
end