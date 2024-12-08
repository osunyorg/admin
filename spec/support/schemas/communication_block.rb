# frozen_string_literal: true
module Schemas
  class CommunicationBlock
    def self.base_schema
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

    def self.template_schema(template_kind)
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

      base_schema.deep_merge({
        title: "Communication::Block (#{template_kind.humanize})",
        properties: {
          data: {
            template_kind: { enum: [template_kind] },
            properties: data_properties
          }
        }
      })
    end

    protected

    def self.component_schema(component)
      component_class = "Communication::Block::Component::#{component[:kind].to_s.classify}".constantize
      schema = { type: component_class.openapi_property_type }
      schema[:enum] = component[:options] if component[:options].present?
      schema.merge(component_class.openapi_property_additional_properties)
    end

    def self.element_schema(element_class)
      schema = { type: :object, properties: {} }
      element_class.components_descriptions.each do |component|
        property = component[:property]
        schema[:properties][property] = component_schema(component)
      end if element_class.components_descriptions.present?
      schema
    end
  end
end