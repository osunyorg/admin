require 'swagger_helper'

RSpec.describe 'Post API' do
  path '/communication/websites/{websiteId}/posts/{locale}' do
    get 'Lists the posts in a website' do
      tags 'Communication::Website::Post'
      consumes 'application/json'
      parameter name: :websiteId,
                in: :path, 
                type: :string, 
                description: 'Website identifier',
                example: 'c8a4bed5-2e05-47e4-90e3-cf334c16453f'
      parameter name: :locale, 
                in: :path, 
                type: :string,
                description: 'Language of the post',
                example: 'fr'

      response '200', 'successful operation' do
        schema type: :object,
          properties: {
            id: { type: :string },
            title: { type: :string },
          },
          required: [ 'name', 'url' ]
        example 'application/json', :response, [
            {
              id: 'c8a4bed5-2e05-47e4-90e3-cf334c16453f',
              title: 'Référentiel général d\'écoconception de services numériques (RGESN)'
            }
          ]
        run_test!
      end
    end
  end
end