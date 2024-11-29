require 'swagger_helper'

RSpec.describe 'Osuny API' do
  fixtures :all

  path '/communication/websites' do
    get 'Lists the websites' do
      tags 'Communication::Website'
      security [{ api_key: [] }]

      response '403', 'unauthorized operation' do
        let("X-Osuny-Token") { 'fake-token' }
        run_test!
      end

      response '200', 'successful operation' do
        let("X-Osuny-Token") { university_apps(:default_app).token }
        run_test!
      end
    end
  end

  # path '/communication/websites/{id}' do
  #   get 'Shows a website' do
  #     tags 'Communication::Website'
  #     parameter name: :id, in: :path, type: :string,
  #               description: 'Identifier', example: '6d8fb0bb-0445-46f0-8954-0e25143e7a58'

  #     let(:id) { '6d8fb0bb-0445-46f0-8954-0e25143e7a58' }
  #     response '200', 'successful operation' do
  #       run_test!
  #     end
  #   end
  # end
end