require 'swagger_helper'

RSpec.describe 'Communication::Website::Post' do
  fixtures :all

  path '/communication/websites/{website_id}/posts' do
    get "Lists a website's posts" do
      tags 'Communication::Website::Post'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }

      response '200', 'Successful operation' do
        run_test!
      end

      response '401', 'Unauthorized. Please make sure you provide a valid API key.' do
        let("X-Osuny-Token") { 'fake-token' }
        run_test!
      end

      response '404', 'Website not found' do
        let(:website_id) { 'fake-id' }
        run_test!
      end
    end

    post 'Creates a post' do
      tags 'Communication::Website::Post'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }

      parameter name: :communication_website_post, in: :body, type: :object, schema: {
        type: :object,
        properties: {
          post: {
            type: :object,
            properties: {
              migration_identifier: { type: :string, description: 'Unique migration identifier of the post' },
              full_width: { type: :boolean },
              localizations_attributes: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    migration_identifier: { type: :string, description: 'Unique migration identifier of the localization' },
                    language: { type: :string, description: 'ISO 639-1 code of the language', example: 'fr' },
                    title: { type: :string },
                    # TODO Featured image & blocks
                    meta_description: { type: :string },
                    pinned: { type: :boolean },
                    published: { type: :boolean },
                    published_at: { type: :string, format: 'date-time' },
                    slug: { type: :string },
                    subtitle: { type: :string },
                    summary: { type: :string },
                    text: { type: :string }
                  },
                  required: [:migration_identifier, :language, :title]
                }
              }
            },
            required: [:migration_identifier, :localizations_attributes]
          }
        },
        required: [:post]
      }
      let(:communication_website_post) { { post: {
        migration_identifier: 'post-from-api-1',
        full_width: false,
        localizations_attributes: [
          {
            migration_identifier: 'post-from-api-1-fr',
            language: 'fr',
            title: 'Ma nouvelle actualité',
            meta_description: 'Une nouvelle actualité depuis l\'API',
            pinned: false,
            published: true,
            published_at: '2024-11-29T16:49:00Z',
            slug: 'ma-nouvelle-actualite',
            subtitle: 'Une nouvelle actualité',
            summary: 'Ceci est une nouvelle actualité créée depuis l\'API.'
          }
        ]
      } } }

      response '201', 'Successful creation' do
        it 'creates a post and its localization', rswag: true do |example|
          assert_difference ->{ Communication::Website::Post.count } => 1, ->{ Communication::Website::Post::Localization.count } => 1 do
            submit_request(example.metadata)
            assert_response_matches_metadata(example.metadata)
          end
        end
      end

      response '400', 'Missing migration identifier.' do
        let(:communication_website_post) { { post: {
          full_width: false,
          localizations_attributes: [
            {
              migration_identifier: 'post-from-api-1-fr',
              language: 'fr',
              title: 'Ma nouvelle actualité',
              meta_description: 'Une nouvelle actualité depuis l\'API',
              pinned: false,
              published: true,
              published_at: '2024-11-29T16:49:00Z',
              slug: 'ma-nouvelle-actualite',
              subtitle: 'Une nouvelle actualité',
              summary: 'Ceci est une nouvelle actualité créée depuis l\'API.'
            }
          ]
        } } }
        run_test!
      end

      response '401', 'Unauthorized. Please make sure you provide a valid API key.' do
        let("X-Osuny-Token") { 'fake-token' }
        run_test!
      end

      response '404', 'Website not found' do
        let(:website_id) { 'fake-id' }
        run_test!
      end

      response '422', 'Invalid parameters' do
        let(:communication_website_post) do
          {
            migration_identifier: 'post-from-api-1',
            full_width: false,
            localizations_attributes: [
              {
                migration_identifier: 'post-from-api-1-fr',
                language: 'fr',
                title: nil
              }
            ]
          }
        end
        run_test!
      end
    end
  end

  path '/communication/websites/{website_id}/posts/{id}' do
    get 'Shows a post' do
      tags 'Communication::Website::Post'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }
      parameter name: :id, in: :path, type: :string, description: 'Post identifier'
      let(:id) { communication_website_posts(:test_post).id }

      response '200', 'Successful operation' do
        run_test!
      end

      response '401', 'Unauthorized. Please make sure you provide a valid API key.' do
        let("X-Osuny-Token") { 'fake-token' }
        run_test!
      end

      response '404', 'Website not found' do
        let(:website_id) { 'fake-id' }
        run_test!
      end

      response '404', 'Post not found' do
        let(:id) { 'fake-id' }
        run_test!
      end
    end

    # patch 'Updates a post' do
    #   tags 'Communication::Website::Post'

    #   parameter name: :website_id, in: :path, type: :string, description: 'Website identifier', example: 'c8a4bed5-2e05-47e4-90e3-cf334c16453f'
    #   parameter name: :id, in: :path, type: :string, description: 'Post identifier', example: '84722b61-f7c3-43c5-9127-2292101af7c5'

    #   response '200', 'successful operation' do
    #     schema type: :object,
    #       properties: {
    #         id: { type: :string },
    #         title: { type: :string },
    #       },
    #       required: [ 'name', 'url' ]
    #     example 'application/json', :response, [
    #         {
    #           id: 'c8a4bed5-2e05-47e4-90e3-cf334c16453f',
    #           title: 'Référentiel général d\'écoconception de services numériques (RGESN)',
    #           published: true,
    #           published_at: 'TODO'
    #         }
    #       ]
    #     run_test!
    #   end
    # end
  end
end
