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
        schemas: {
          communication_website: Schemas::CommunicationWebsite.schema,
          communication_website_localization: Schemas::CommunicationWebsiteLocalization.schema,
          communication_website_post: Schemas::CommunicationWebsitePost.schema,
          communication_website_post_localization: Schemas::CommunicationWebsitePostLocalization.schema,
          communication_block: Schemas::CommunicationBlock.schema,
        }
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
