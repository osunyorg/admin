require 'swagger_helper'

RSpec.describe 'Osuny API' do
  path '/communication/websites' do
    get 'Lists the websites' do
      tags 'Communication::Website'
      response '200', 'successful operation' do
        schema type: :object, properties: {
          id: { 
            type: :string, 
            example: '6d8fb0bb-0445-46f0-8954-0e25143e7a58', 
            title: 'Website identifier' 
          },
          name: { 
            type: :string,
            example: 'Site de démo',
            title: 'Nom du site'
          },
          url: { 
            type: :string,
            example: 'https://example.osuny.org',
            title: 'URL du site'
          },
        }
        run_test!
      end
    end
  end
  path '/communication/websites/{id}' do
    get 'Shows a website' do
      tags 'Communication::Website'
      parameter name: :id, in: :path, type: :string, 
                description: 'Identifier', example: '6d8fb0bb-0445-46f0-8954-0e25143e7a58'

      let(:id) { '6d8fb0bb-0445-46f0-8954-0e25143e7a58' }
      response '200', 'successful operation' do
        run_test!
      end
    end
  end
end