require 'swagger_helper'

RSpec.describe 'Blogs API' do

  path '/communication/websites' do

    get 'Lists websites' do
      tags 'Websites'
      consumes 'application/json'

      response '200', 'successful operation' do
        schema type: :object,
          properties: {
            name: { type: :string },
            url: { type: :string },
          },
          required: [ 'name', 'url' ]
        run_test!
      end
    end
  end
end