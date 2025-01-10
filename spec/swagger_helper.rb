# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('openapi').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  schemas = {
    communication_website: Communication::Website::OPENAPI_SCHEMA,
    communication_website_localization: Communication::Website::Localization::OPENAPI_SCHEMA,
    communication_website_page: Communication::Website::Page::OPENAPI_SCHEMA,
    communication_website_page_localization: Communication::Website::Page::Localization::OPENAPI_SCHEMA,
    communication_website_post: Communication::Website::Post::OPENAPI_SCHEMA,
    communication_website_post_localization: Communication::Website::Post::Localization::OPENAPI_SCHEMA,
    communication_website_agenda_event: Communication::Website::Agenda::Event::OPENAPI_SCHEMA,
    communication_website_agenda_event_localization: Communication::Website::Agenda::Event::Localization::OPENAPI_SCHEMA,
    university_organization: University::Organization::OPENAPI_SCHEMA,
    university_organization_localization: University::Organization::Localization::OPENAPI_SCHEMA,
  }
  Communication::Block.template_kinds.keys.each do |template_kind|
    schema_key = "communication_block_#{template_kind}".to_sym
    schemas[schema_key] = Communication::Block.openapi_schema_for_template(template_kind)
  end

  config.openapi_specs = {
    'osuny/v1/openapi.json' => {
      openapi: '3.0.1',
      info: {
        title: 'Osuny',
        version: 'v1'
      },
      servers: [
        # initializer rswag_api prefixes with the instance
        url: '/api/osuny/v1'
      ],
      consumes: [
        'application/json'
      ],
      produces: [
        'application/json'
      ],
      security: [
        { api_key: [] }
      ],
      components: {
        securitySchemes: {
          api_key: {
            type: :apiKey,
            name: 'X-Osuny-Token',
            in: :header
          }
        },
        schemas: schemas
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :json

  config.after(:each) do |example|
    next if response.body.blank?
    example.metadata[:response][:content] = {
      'application/json' => {
        examples: {
          example.metadata[:example_group][:description] => {
            value: JSON.parse(response.body, symbolize_names: true)
          }
        }
      }
    }
  end
end
