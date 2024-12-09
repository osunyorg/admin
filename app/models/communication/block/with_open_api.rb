module Communication::Block::WithOpenApi
  extend ActiveSupport::Concern

  included do
    OPENAPI_SCHEMA = {
      type: :object,
      title: "Communication::Block",
      properties: {
        id: { type: :string, format: :uuid, nullable: true },
        migration_identifier: { type: :string, nullable: true },
        template_kind: { type: :string, description: "Template kind of the blocks.", enum: self.template_kinds.keys },
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

  class_methods do
    def openapi_schema_for_template(template_kind)
      template_class = "Communication::Block::Template::#{template_kind.classify}".constantize
      data_properties = {}

      template_class.components_descriptions.each do |component|
        property = component[:property]
        data_properties[property] = component_schema(component)
      end if template_class.components_descriptions.present?

      data_properties[:elements] = {
        type: :array,
        items: element_schema(template_class.element_class)
      } if template_class.element_class.present?

      OPENAPI_SCHEMA.deep_merge({
        title: "Communication::Block (#{template_kind.humanize})",
        properties: {
          template_kind: { enum: [template_kind] },
          data: {
            properties: data_properties
          }
        }
      })
    end

    def templates_openapi_schema_references
      self.template_kinds.keys.map do |template_kind|
        { "$ref": "#/components/schemas/communication_block_#{template_kind}" }
      end
    end

    protected

    def component_schema(component)
      component_class = "Communication::Block::Component::#{component[:kind].to_s.classify}".constantize
      schema = { type: component_class.openapi_property_type }
      schema[:format] = component_class.openapi_property_format if component_class.openapi_property_format.present?
      schema[:enum] = component[:options] if component[:options].present?
      schema.merge(component_class.openapi_property_additional_properties)
    end

    def element_schema(element_class)
      schema = { type: :object, properties: {} }
      element_class.components_descriptions.each do |component|
        property = component[:property]
        schema[:properties][property] = component_schema(component)
      end if element_class.components_descriptions.present?
      schema
    end
  end
end