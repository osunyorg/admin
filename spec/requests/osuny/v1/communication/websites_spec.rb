require 'swagger_helper'

RSpec.describe 'Communication::Website' do
  fixtures :all

  path '/communication/websites' do
    get 'Lists the websites' do
      tags 'Communication::Website'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      response '200', 'Successful operation' do
        schema type: :array, items: { '$ref' => '#/components/schemas/communication_website' }
        run_test!
      end

      response '401', 'Unauthorized. Please make sure you provide a valid API key.' do
        let("X-Osuny-Token") { 'fake-token' }
        run_test!
      end
    end
  end

  path '/communication/websites/{id}' do
    get 'Shows a website' do
      tags 'Communication::Website'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :id, in: :path, type: :string, description: 'Website identifier'
      let(:id) { communication_websites(:website_with_github).id }

      response '200', 'Successful operation' do
        schema '$ref' => '#/components/schemas/communication_website'
        run_test!
      end

      response '401', 'Unauthorized. Please make sure you provide a valid API key.' do
        let("X-Osuny-Token") { 'fake-token' }
        run_test!
      end

      response '404', 'Website not found' do
        let(:id) { 'fake-id' }
        run_test!
      end
    end
  end
end