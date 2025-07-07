require 'swagger_helper'

RSpec.describe 'Communication::Media' do
  fixtures :all

  path '/communication/medias' do
    post 'Create a media' do
      tags 'Communication::Website::Media'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      consumes 'multipart/form-data'

      parameter name: :media, in: :formData, schema: {
        type: :object,
        properties: {
          url: { type: :string },
          file: { type: :string, format: :binary }
        }
      }
      let(:media) { { url: nil, file: nil } }
      parameter name: :url, in: :formData, type: :string
      let(:url) { nil }
      parameter name: :file, in: :formData, type: :file
      let(:file) { nil }

      response '201', 'Successful creation from URL' do
        let(:url) { "https://images.unsplash.com/photo-1703923633616-254e78f6e9df?q=80&w=2070&auto=format&fit=crop" }
        it 'creates a media and its localization from url', vcr: true, rswag: true do |example|
          assert_difference ->{ Communication::Media.count } => 1, ->{ Communication::Media::Localization.count } => 1 do
            submit_request(example.metadata)
            assert_response_matches_metadata(example.metadata)
          end
        end
      end

      response '201', 'Successful creation from file' do
        let(:file) { fixture_file_upload('dan-gold.jpeg', 'image/jpeg') }
        it 'creates a media and its localization from file', vcr: true, rswag: true do |example|
          assert_difference ->{ Communication::Media.count } => 1, ->{ Communication::Media::Localization.count } => 1 do
            submit_request(example.metadata)
            assert_response_matches_metadata(example.metadata)
          end
        end
      end

      response '401', 'Unauthorized. Please make sure you provide a valid API key.' do
        let("X-Osuny-Token") { 'fake-token' }
        run_test!
      end
    end
  end
end