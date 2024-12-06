require 'swagger_helper'

RSpec.describe 'Communication::Block::Template' do
  fixtures :all

  # path '/communication/blocks/templates' do
  #   get 'Lists available block templates' do
  #     tags 'Communication::Block::Template'
  #     security [{ api_key: [] }]
  #     let("X-Osuny-Token") { university_apps(:default_app).token }

  #     parameter name: :category,
  #               getter: :filter_category,
  #               in: :query,
  #               schema: {
  #                 type: :string,
  #                 enum: Communication::Block::CATEGORIES.keys,
  #               },
  #               required: false

  #     response '200', 'List all templates' do
  #       run_test!
  #     end

  #     response '200', 'Basic templates' do
  #       let(:filter_category) { 'basic' }
  #       run_test!
  #     end

  #     response '200', 'Storytelling templates' do
  #       let(:filter_category) { 'storytelling' }
  #       run_test!
  #     end

  #     response '401', 'Unauthorized. Please make sure you provide a valid API key.' do
  #       let("X-Osuny-Token") { 'fake-token' }
  #       run_test!
  #     end
  #   end
  # end

  # path '/communication/blocks/templates/{id}' do
  #   get 'Shows a block template definition' do
  #     tags 'Communication::Block::Template'
  #     security [{ api_key: [] }]
  #     let("X-Osuny-Token") { university_apps(:default_app).token }

  #     parameter name: :id, in: :path, type: :string, description: 'Template identifier'

  #     let(:id) { 'chapter' }

  #     response '200', 'Chapter' do
  #       run_test!
  #     end

  #     response '200', 'Gallery' do
  #       let(:id) { 'gallery' }
  #       run_test!
  #     end

  #     response '200', 'Posts' do
  #       let(:id) { 'posts' }
  #       run_test!
  #     end

  #     response '200', 'Files' do
  #       let(:id) { 'files' }
  #       run_test!
  #     end

  #     response '401', 'Unauthorized. Please make sure you provide a valid API key.' do
  #       let("X-Osuny-Token") { 'fake-token' }
  #       run_test!
  #     end

  #     response '404', 'Template not found' do
  #       let(:id) { 'fake-id' }
  #       run_test!
  #     end
  #   end
  # end
end