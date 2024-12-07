module Schemas
  class CommunicationBlock
    def self.schema
      {
        type: :object,
        title: "Communication::Block",
        properties: {
          migration_identifier: { type: :string },
          template_kind: { type: :string, description: "Template kind of the blocks.", enum: Communication::Block.template_kinds.keys },
          title: { type: :string },
          position: { type: :integer },
          published: { type: :boolean, default: true },
          html_class: { type: :string, description: "For advanced use. Add an HTML class for custom purposes." },
          data: {
            type: :object,
            description: "Data of the block. The structure depends on the template kind.",
            additionalProperties: true
          }
        }
      }
    end
  end
end