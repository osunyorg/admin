# require 'swagger_helper'

# RSpec.describe 'Post API' do
#   path '/communication/websites/{website_id}/posts' do
#     get 'Lists the posts in a website' do
#       tags 'Communication::Website::Post'

#       parameter name: :website_id, in: :path, type: :string, description: 'Website identifier', example: '6d8fb0bb-0445-46f0-8954-0e25143e7a58'

#       response '200', 'successful operation' do
#         schema type: :object, properties: {
#             id: { type: :string },
#             title: { type: :string },
#           }, equired: [ 'name', 'url' ]
#         example 'application/json', :response, [
#             {
#               id: 'c8a4bed5-2e05-47e4-90e3-cf334c16453f',
#               title: 'Référentiel général d\'écoconception de services numériques (RGESN)'
#             }
#           ]
#         run_test!
#       end
#     end

#     post 'Creates a post' do
#       tags 'Communication::Website::Post'

#       parameter name: :website_id, in: :path, type: :string, description: 'Website identifier', example: '6d8fb0bb-0445-46f0-8954-0e25143e7a58'
#       parameter name: :blog, in: :body, type: :object, schema: {
#         type: :object,
#         properties: {
#           title: { type: :string, description: 'Title', example: 'This is a post' },
#           summary: { type: :string, description: 'Summary', example: 'This is a summary' },
#           migration_identifier: { type: :string, description: 'Unique migration identifier' },
#           published: { type: :boolean, example: false },
#           locale: { type: :string, description: 'Locale', example: 'fr' },
#         },
#         required: %[title migration_identifier]
#       }

#       response '200', 'successful operation' do
#         schema type: :object, properties: {
#             id: { type: :string },
#             title: { type: :string },
#           }, required: [ 'id', 'title' ]
#         example 'application/json', :response, [
#             {
#               id: 'c8a4bed5-2e05-47e4-90e3-cf334c16453f',
#               title: 'Référentiel général d\'écoconception de services numériques (RGESN)',
#               published: true,
#               published_at: 'TODO'
#             }
#           ]
#         run_test!
#       end

#     end
#   end

#   path '/communication/websites/{website_id}/posts/{id}' do
#     get 'Shows a post' do
#       tags 'Communication::Website::Post'

#       parameter name: :website_id, in: :path, type: :string, description: 'Website identifier', example: '6d8fb0bb-0445-46f0-8954-0e25143e7a58'
#       parameter name: :id, in: :path, type: :string, description: 'Post identifier', example: '84722b61-f7c3-43c5-9127-2292101af7c5'

#       response '200', 'successful operation' do
#         schema type: :object,
#           properties: {
#             id: { type: :string },
#             title: { type: :string },
#           },
#           required: [ 'name', 'url' ]
#         example 'application/json', :response, [
#             {
#               id: 'c8a4bed5-2e05-47e4-90e3-cf334c16453f',
#               title: 'Référentiel général d\'écoconception de services numériques (RGESN)'
#             }
#           ]
#         run_test!
#       end
#     end

#     patch 'Updates a post' do
#       tags 'Communication::Website::Post'

#       parameter name: :website_id, in: :path, type: :string, description: 'Website identifier', example: 'c8a4bed5-2e05-47e4-90e3-cf334c16453f'
#       parameter name: :id, in: :path, type: :string, description: 'Post identifier', example: '84722b61-f7c3-43c5-9127-2292101af7c5'

#       response '200', 'successful operation' do
#         schema type: :object,
#           properties: {
#             id: { type: :string },
#             title: { type: :string },
#           },
#           required: [ 'name', 'url' ]
#         example 'application/json', :response, [
#             {
#               id: 'c8a4bed5-2e05-47e4-90e3-cf334c16453f',
#               title: 'Référentiel général d\'écoconception de services numériques (RGESN)',
#               published: true,
#               published_at: 'TODO'
#             }
#           ]
#         run_test!
#       end
#     end
#   end
# end
