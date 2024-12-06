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
          # featured_image: { type: :string, description: 'URL of the featured image' },
          featured_image_alt: { type: :string, description: 'Alternative text of the featured image', nullable: true },
          featured_image_credit: { type: :string, description: 'Credit of the featured image', nullable: true },
          meta_description: { type: :string, nullable: true },
          pinned: { type: :boolean },
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