require 'swagger_helper'

RSpec.describe 'Communication::Website::Post' do
  fixtures :all

  COMMUNICATION_WEBSITE_POST_SCHEMA = {
    type: :object,
    properties: {
      post: {
        type: :object,
        properties: {
          migration_identifier: { type: :string, description: 'Unique migration identifier of the post' },
          full_width: { type: :boolean },
          localizations: {
            type: :object,
            description: "Localizations of the post. The key is the language's ISO 639-1 code.",
            additionalProperties: {
              type: :object,
              properties: {
                migration_identifier: { type: :string, description: 'Unique migration identifier of the localization' },
                title: { type: :string },
                featured_image: { type: :string, description: 'URL of the featured image' },
                featured_image_alt: { type: :string, description: 'Alternative text of the featured image' },
                featured_image_credit: { type: :string, description: 'Credit of the featured image' },
                meta_description: { type: :string },
                pinned: { type: :boolean },
                published: { type: :boolean },
                published_at: { type: :string, format: 'date-time' },
                slug: { type: :string },
                subtitle: { type: :string },
                summary: { type: :string },
                text: { type: :string },
                blocks: {
                  type: :array,
                  items: {
                    type: :object,
                    properties: {
                      migration_identifier: { type: :string },
                      template_kind: { type: :string, description: "Template kind of the blocks. See /communication/blocks/templates for possible values." },
                      title: { type: :string },
                      position: { type: :integer },
                      published: { type: :boolean, default: true },
                      html_class: { type: :string, description: "For advanced use. Add an HTML class for custom purposes." },
                      data: {
                        type: :object,
                        description: "Data of the block. The structure depends on the template kind.",
                        additionalProperties: true
                      }
                    }
                  }
                }
              },
              required: [:migration_identifier, :title]
            },
            example: {
              fr: {
                migration_identifier: "string",
                title: "string",
                featured_image: "string",
                featured_image_alt: "string",
                featured_image_credit: "string",
                meta_description: "string",
                pinned: true,
                published: true,
                published_at: Time.zone.now,
                slug: "string",
                subtitle: "string",
                summary: "string",
                text: "string",
                blocks: [
                  {
                    migration_identifier: "string",
                    template_kind: "string",
                    title: "string",
                    position: 1,
                    published: true,
                    html_class: "string",
                    data: {
                      key: "value"
                    }
                  }
                ]
              }
            }
          }
        },
        required: [:migration_identifier, :localizations]
      }
    },
    required: [:post]
  }

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

      parameter name: :communication_website_post, in: :body, type: :object, schema: COMMUNICATION_WEBSITE_POST_SCHEMA
      let(:communication_website_post) {
        {
          post: {
            migration_identifier: 'post-from-api-1',
            full_width: false,
            localizations: {
              fr: {
                migration_identifier: 'post-from-api-1-fr',
                title: 'Ma nouvelle actualité',
                meta_description: 'Une nouvelle actualité depuis l\'API',
                featured_image: 'https://images.unsplash.com/photo-1703923633616-254e78f6e9df?q=80&w=2070&auto=format&fit=crop',
                featured_image_alt: 'La lumière brille sur les parois du canyon',
                featured_image_credit: 'Photo de <a href="https://unsplash.com/fr/@johnnzhou">John Zhou</a> sur <a href="https://unsplash.com/fr/photos/la-lumiere-brille-sur-les-parois-du-canyon-AM-G-Yp5hIk">Unsplash</a>',
                pinned: false,
                published: true,
                published_at: '2024-11-29T16:49:00Z',
                slug: 'ma-nouvelle-actualite',
                subtitle: 'Une nouvelle actualité',
                summary: 'Ceci est une nouvelle actualité créée depuis l\'API.'
              }
            }
          }
        }
      }

      response '201', 'Successful creation' do
        it 'creates a post and its localization', rswag: true, vcr: true do |example|
          assert_difference ->{ Communication::Website::Post.count } => 1, ->{ Communication::Website::Post::Localization.count } => 1 do
            submit_request(example.metadata)
            assert_response_matches_metadata(example.metadata)
          end
        end
      end

      response '400', 'Missing migration identifier.' do
        let(:communication_website_post) {
          {
            post: {
              full_width: false,
              localizations: {
                fr: {
                  migration_identifier: 'post-from-api-1-fr',
                  title: 'Ma nouvelle actualité',
                  meta_description: 'Une nouvelle actualité depuis l\'API',
                  pinned: false,
                  published: true,
                  published_at: '2024-11-29T16:49:00Z',
                  slug: 'ma-nouvelle-actualite',
                  subtitle: 'Une nouvelle actualité',
                  summary: 'Ceci est une nouvelle actualité créée depuis l\'API.'
                }
              }
            }
          }
        }
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
        let(:communication_website_post) {
          {
            post: {
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
          }
        }
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

    patch 'Updates a post' do
      tags 'Communication::Website::Post'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }
      parameter name: :id, in: :path, type: :string, description: 'Post identifier'
      let(:id) { communication_website_posts(:test_post).id }

      parameter name: :communication_website_post, in: :body, type: :object, schema: COMMUNICATION_WEBSITE_POST_SCHEMA
      let(:communication_website_post) {
        test_post = communication_website_posts(:test_post)
        test_post_l10n = communication_website_post_localizations(:test_post_fr)
        {
          post: {
            migration_identifier: test_post.migration_identifier,
            full_width: test_post.full_width,
            localizations: {
              test_post_l10n.language.iso_code => {
                migration_identifier: test_post_l10n.migration_identifier,
                title: "Mon nouveau titre",
                meta_description: test_post_l10n.meta_description,
                pinned: test_post_l10n.pinned,
                published: test_post_l10n.published,
                published_at: test_post_l10n.published_at,
                slug: test_post_l10n.slug,
                subtitle: test_post_l10n.subtitle,
                summary: test_post_l10n.summary
              }
            }
          }
        }
      }

      response '200', 'Successful update' do
        run_test! do |response|
          assert_equal("Mon nouveau titre", communication_website_post_localizations(:test_post_fr).reload.title)
        end
      end

      response '400', 'Missing migration identifier.' do
        let(:communication_website_post) {
          test_post = communication_website_posts(:test_post)
          test_post_l10n = communication_website_post_localizations(:test_post_fr)
          {
            post: {
              full_width: test_post.full_width,
              localizations: {
                test_post_l10n.language.iso_code => {
                  migration_identifier: test_post_l10n.migration_identifier,
                  title: test_post_l10n.title,
                  meta_description: test_post_l10n.meta_description,
                  pinned: test_post_l10n.pinned,
                  published: test_post_l10n.published,
                  published_at: test_post_l10n.published_at,
                  slug: test_post_l10n.slug,
                  subtitle: test_post_l10n.subtitle,
                  summary: test_post_l10n.summary
                }
              }
            }
          }
        }
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

      response '422', 'Invalid parameters' do
        let(:communication_website_post) {
          test_post = communication_website_posts(:test_post)
          test_post_l10n = communication_website_post_localizations(:test_post_fr)
          {
            post: {
              migration_identifier: test_post.migration_identifier,
              full_width: test_post.full_width,
              localizations: {
                test_post_l10n.language.iso_code => {
                  migration_identifier: test_post_l10n.migration_identifier,
                  title: nil,
                  meta_description: test_post_l10n.meta_description,
                  pinned: test_post_l10n.pinned,
                  published: test_post_l10n.published,
                  published_at: test_post_l10n.published_at,
                  slug: test_post_l10n.slug,
                  subtitle: test_post_l10n.subtitle,
                  summary: test_post_l10n.summary
                }
              }
            }
          }
        }
        run_test!
      end
    end

    delete 'Deletes a post' do
      tags 'Communication::Website::Post'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }
      parameter name: :id, in: :path, type: :string, description: 'Post identifier'
      let(:id) { communication_website_posts(:test_post).id }

      response '204', 'Successful deletion' do
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
  end
end
