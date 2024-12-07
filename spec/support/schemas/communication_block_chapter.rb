module Schemas
  class CommunicationBlockChapter
    def self.schema
      template_class = Communication::Block::Template::Chapter
      properties = {}
      template_class.components_descriptions.each do |component|
        property = component[:property]
        properties[property] = {
          type: component[:kind]
        }
      end
      {
        type: :object,
        title: "Communication::Block (Chapter)",
        properties: {
          migration_identifier: { type: :string },
          template_kind: { type: :string, description: "Template kind of the blocks.", enum: ["chapter"] },
          title: { type: :string },
          position: { type: :integer },
          published: { type: :boolean, default: true },
          html_class: { type: :string, description: "For advanced use. Add an HTML class for custom purposes." },
          data: {
            type: :object,
            description: "Data of the block. The structure depends on the template kind.",
            properties: properties
          }
        }
      }
    end
  end
end