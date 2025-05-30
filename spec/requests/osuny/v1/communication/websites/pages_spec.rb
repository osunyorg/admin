require 'swagger_helper'

RSpec.describe 'Communication::Website::Page' do
  fixtures :all

  path '/communication/websites/{website_id}/pages' do
    get "Lists a website's pages" do
      tags 'Communication::Website::Page'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }

      response '200', 'Successful operation' do
        schema type: :array, items: { '$ref' => '#/components/schemas/communication_website_page' }
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

    post 'Creates a page' do
      tags 'Communication::Website::Page'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }

      parameter name: :communication_website_page, in: :body, type: :object, schema: {
        type: :object,
        properties: {
          page: {
            '$ref': '#/components/schemas/communication_website_page'
          }
        },
        required: [:page]
      }
      let(:communication_website_page) {
        page_category = communication_website_page_categories(:test_category)
        {
          page: {
            migration_identifier: 'page-from-api-1',
            parent_id: communication_website_pages(:root_page).id,
            full_width: true,
            category_ids: [page_category.id],
            localizations: {
              fr: {
                migration_identifier: 'page-from-api-1-fr',
                title: 'Ma nouvelle page',
                breadcrumb_title: 'Nouvelle page',
                meta_description: 'Une nouvelle page depuis l\'API',
                featured_image: {
                  url: 'https://images.unsplash.com/photo-1703923633616-254e78f6e9df?q=80&w=2070&auto=format&fit=crop',
                  alt: 'La lumière brille sur les parois du canyon',
                  credit: 'Photo de <a href="https://unsplash.com/fr/@johnnzhou">John Zhou</a> sur <a href="https://unsplash.com/fr/photos/la-lumiere-brille-sur-les-parois-du-canyon-AM-G-Yp5hIk">Unsplash</a>'
                },
                published: true,
                published_at: '2024-11-29T16:49:00Z',
                slug: 'ma-nouvelle-page',
                summary: 'Ceci est une nouvelle page créée depuis l\'API.',
                header_text: 'Bienvenue sur ma nouvelle page',
                header_cta: true,
                header_cta_label: 'Découvrir',
                header_cta_url: 'https://www.example.com',
                blocks: [
                  {
                    migration_identifier: 'page-from-api-1-fr-block-1',
                    template_kind: 'chapter',
                    title: 'Mon premier chapitre',
                    position: 1,
                    published: true,
                    data: {
                      layout: "no_background",
                      text: "<p>Ceci est mon premier chapitre</p>"
                    }
                  }
                ]
              }
            }
          }
        }
      }

      response '201', 'Successful creation' do
        it 'creates a page and its localization', rswag: true do |example|
          assert_difference ->{ Communication::Website::Page.count } => 1, ->{ Communication::Website::Page::Localization.count } => 1 do
            assert_enqueued_jobs 1, only: Api::AttachFeaturedImageFromUrlJob do
              submit_request(example.metadata)
              assert_response_matches_metadata(example.metadata)
            end
          end
        end
      end

      response '400', 'Missing migration identifier.' do
        let(:communication_website_page) {
          {
            page: {
              parent_id: communication_website_pages(:root_page).id,
              full_width: true,
              localizations: {
                fr: {
                  migration_identifier: 'page-from-api-1-fr',
                  title: 'Ma nouvelle page',
                  breadcrumb_title: 'Nouvelle page',
                  meta_description: 'Une nouvelle page depuis l\'API',
                  published: true,
                  published_at: '2024-11-29T16:49:00Z',
                  slug: 'ma-nouvelle-page',
                  summary: 'Ceci est une nouvelle page créée depuis l\'API.',
                  header_text: 'Bienvenue sur ma nouvelle page',
                  header_cta: true,
                  header_cta_label: 'Découvrir',
                  header_cta_url: 'https://www.example.com'
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
        let(:communication_website_page) {
          {
            page: {
              migration_identifier: 'page-from-api-1',
              parent_id: communication_website_pages(:root_page).id,
              full_width: true,
              localizations: {
                fr: {
                  migration_identifier: 'page-from-api-1-fr',
                  meta_description: 'Une nouvelle page depuis l\'API',
                  published: true,
                  published_at: '2024-11-29T16:49:00Z',
                  summary: 'Ceci est une nouvelle page créée depuis l\'API.'
                }
              }
            }
          }
        }
        run_test!
      end
    end
  end

  path '/communication/websites/{website_id}/pages/upsert' do
    post 'Upsert pages' do
      tags 'Communication::Website::Page'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }

      parameter name: :pages, in: :body, type: :object, schema: {
        type: :object,
        properties: {
          pages: {
            type: :array,
            items: {
              '$ref': '#/components/schemas/communication_website_page'
            }
          }
        },
        required: [:pages]
      }
      let(:pages) {
        test_page = communication_website_pages(:test_page)
        test_page_l10n = communication_website_page_localizations(:test_page_fr)
        page_category = communication_website_page_categories(:test_category)
        {
          pages: [
            {
              migration_identifier: 'page-from-api-1',
              parent_id: communication_website_pages(:root_page).id,
              full_width: true,
              category_ids: [page_category.id],
              localizations: {
                fr: {
                  migration_identifier: 'page-from-api-1-fr',
                  title: 'Ma nouvelle page',
                  breadcrumb_title: 'Nouvelle page',
                  meta_description: 'Une nouvelle page depuis l\'API',
                  featured_image: {
                    url: 'https://images.unsplash.com/photo-1703923633616-254e78f6e9df?q=80&w=2070&auto=format&fit=crop',
                    alt: 'La lumière brille sur les parois du canyon',
                    credit: 'Photo de <a href="https://unsplash.com/fr/@johnnzhou">John Zhou</a> sur <a href="https://unsplash.com/fr/photos/la-lumiere-brille-sur-les-parois-du-canyon-AM-G-Yp5hIk">Unsplash</a>'
                  },
                  published: true,
                  published_at: '2024-11-29T16:49:00Z',
                  slug: 'ma-nouvelle-page',
                  summary: 'Ceci est une nouvelle page créée depuis l\'API.',
                  header_text: 'Bienvenue sur ma nouvelle page',
                  header_cta: true,
                  header_cta_label: 'Découvrir',
                  header_cta_url: 'https://www.example.com',
                  blocks: [
                    {
                      migration_identifier: 'page-from-api-1-fr-block-1',
                      template_kind: 'chapter',
                      title: 'Mon premier chapitre',
                      position: 1,
                      published: true,
                      data: {
                        layout: "no_background",
                        text: "<p>Ceci est mon premier chapitre</p>"
                      }
                    }
                  ]
                }
              }
            },
            {
              migration_identifier: test_page.migration_identifier,
              parent_id: test_page.parent_id,
              full_width: test_page.full_width,
              category_ids: test_page.category_ids,
              localizations: {
                test_page_l10n.language.iso_code => {
                  migration_identifier: test_page_l10n.migration_identifier,
                  title: "Mon nouveau titre",
                  breadcrumb_title: test_page_l10n.breadcrumb_title,
                  meta_description: test_page_l10n.meta_description,
                  published: test_page_l10n.published,
                  published_at: test_page_l10n.published_at,
                  slug: test_page_l10n.slug,
                  summary: test_page_l10n.summary,
                  header_text: test_page_l10n.header_text,
                  header_cta: test_page_l10n.header_cta,
                  header_cta_label: test_page_l10n.header_cta_label,
                  header_cta_url: test_page_l10n.header_cta_url
                }
              }
            }
          ]
        }
      }

      response '200', 'Successful upsertion' do
        it 'creates a page and updates another with their localizations', rswag: true do |example|
          assert_difference ->{ Communication::Website::Page.count } => 1, ->{ Communication::Website::Page::Localization.count } => 1 do
            assert_enqueued_jobs 1, only: Api::AttachFeaturedImageFromUrlJob do
              submit_request(example.metadata)
              assert_response_matches_metadata(example.metadata)
            end
          end
        end
      end

      response '400', 'Missing migration identifier.' do
        let(:pages) {
          test_page = communication_website_pages(:test_page)
          test_page_l10n = communication_website_page_localizations(:test_page_fr)
          {
            pages: [
              {
                migration_identifier: 'page-from-api-1',
                parent_id: communication_website_pages(:root_page).id,
                full_width: true,
                localizations: {
                  fr: {
                    migration_identifier: 'page-from-api-1-fr',
                    title: 'Ma nouvelle page',
                    breadcrumb_title: 'Nouvelle page',
                    meta_description: 'Une nouvelle page depuis l\'API',
                    featured_image: {
                      url: 'https://images.unsplash.com/photo-1703923633616-254e78f6e9df?q=80&w=2070&auto=format&fit=crop',
                      alt: 'La lumière brille sur les parois du canyon',
                      credit: 'Photo de <a href="https://unsplash.com/fr/@johnnzhou">John Zhou</a> sur <a href="https://unsplash.com/fr/photos/la-lumiere-brille-sur-les-parois-du-canyon-AM-G-Yp5hIk">Unsplash</a>'
                    },
                    published: true,
                    published_at: '2024-11-29T16:49:00Z',
                    slug: 'ma-nouvelle-page',
                    summary: 'Ceci est une nouvelle page créée depuis l\'API.',
                    header_text: 'Bienvenue sur ma nouvelle page',
                    header_cta: true,
                    header_cta_label: 'Découvrir',
                    header_cta_url: 'https://www.example.com',
                    blocks: [
                      {
                        migration_identifier: 'page-from-api-1-fr-block-1',
                        template_kind: 'chapter',
                        title: 'Mon premier chapitre',
                        position: 1,
                        published: true,
                        data: {
                          layout: "no_background",
                          text: "<p>Ceci est mon premier chapitre</p>"
                        }
                      }
                    ]
                  }
                }
              },
              {
                parent_id: test_page.parent_id,
                full_width: test_page.full_width,
                localizations: {
                  test_page_l10n.language.iso_code => {
                    migration_identifier: test_page_l10n.migration_identifier,
                    title: "Mon nouveau titre",
                    breadcrumb_title: test_page_l10n.breadcrumb_title,
                    meta_description: test_page_l10n.meta_description,
                    published: test_page_l10n.published,
                    published_at: test_page_l10n.published_at,
                    slug: test_page_l10n.slug,
                    summary: test_page_l10n.summary,
                    header_text: test_page_l10n.header_text,
                    header_cta: test_page_l10n.header_cta,
                    header_cta_label: test_page_l10n.header_cta_label,
                    header_cta_url: test_page_l10n.header_cta_url
                  }
                }
              }
            ]
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
        let(:pages) {
          test_page = communication_website_pages(:test_page)
          test_page_l10n = communication_website_page_localizations(:test_page_fr)
          {
            pages: [
              {
                migration_identifier: 'page-from-api-1',
                full_width: false,
                localizations: {
                  fr: {
                    migration_identifier: 'page-from-api-1-fr',
                    title: nil
                  }
                }
              },
              {
                migration_identifier: test_page.migration_identifier,
                full_width: test_page.full_width,
                localizations: {
                  test_page_l10n.language.iso_code => {
                    migration_identifier: test_page_l10n.migration_identifier,
                    title: nil
                  }
                }
              }
            ]
          }
        }
        run_test!
      end
    end
  end

  path '/communication/websites/{website_id}/pages/{id}' do
    get 'Shows a page' do
      tags 'Communication::Website::Page'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }
      parameter name: :id, in: :path, type: :string, description: 'Page identifier'
      let(:id) { communication_website_pages(:test_page).id }

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

      response '404', 'Page not found' do
        let(:id) { 'fake-id' }
        run_test!
      end
    end

    patch 'Updates a page' do
      tags 'Communication::Website::Page'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }
      parameter name: :id, in: :path, type: :string, description: 'Page identifier'
      let(:id) { communication_website_pages(:test_page).id }

      parameter name: :communication_website_page, in: :body, type: :object, schema: {
        type: :object,
        properties: {
          page: {
            '$ref': '#/components/schemas/communication_website_page'
          }
        },
        required: [:page]
      }
      let(:communication_website_page) {
        test_page = communication_website_pages(:test_page)
        test_page_l10n = communication_website_page_localizations(:test_page_fr)
        {
          page: {
            migration_identifier: test_page.migration_identifier,
            parent_id: test_page.parent_id,
            full_width: test_page.full_width,
            category_ids: test_page.category_ids,
            localizations: {
              test_page_l10n.language.iso_code => {
                migration_identifier: test_page_l10n.migration_identifier,
                title: "Mon nouveau titre",
                breadcrumb_title: test_page_l10n.breadcrumb_title,
                meta_description: test_page_l10n.meta_description,
                published: test_page_l10n.published,
                published_at: test_page_l10n.published_at,
                slug: test_page_l10n.slug,
                summary: test_page_l10n.summary,
                header_text: test_page_l10n.header_text,
                header_cta: test_page_l10n.header_cta,
                header_cta_label: test_page_l10n.header_cta_label,
                header_cta_url: test_page_l10n.header_cta_url
              }
            }
          }
        }
      }

      response '200', 'Successful update' do
        run_test! do |response|
          assert_equal("Mon nouveau titre", communication_website_page_localizations(:test_page_fr).reload.title)
        end
      end

      response '400', 'Missing migration identifier.' do
        let(:communication_website_page) {
          test_page = communication_website_pages(:test_page)
          test_page_l10n = communication_website_page_localizations(:test_page_fr)
          {
            page: {
              parent_id: test_page.parent_id,
              full_width: test_page.full_width,
              category_ids: test_page.category_ids,
              localizations: {
                test_page_l10n.language.iso_code => {
                  migration_identifier: test_page_l10n.migration_identifier,
                  title: "Mon nouveau titre",
                  breadcrumb_title: test_page_l10n.breadcrumb_title,
                  meta_description: test_page_l10n.meta_description,
                  published: test_page_l10n.published,
                  published_at: test_page_l10n.published_at,
                  slug: test_page_l10n.slug,
                  summary: test_page_l10n.summary,
                  header_text: test_page_l10n.header_text,
                  header_cta: test_page_l10n.header_cta,
                  header_cta_label: test_page_l10n.header_cta_label,
                  header_cta_url: test_page_l10n.header_cta_url
                }
              }
            }
          }
        }
        run_test!
      end

      # TODO: Add test for missing migration identifier in localization

      response '401', 'Unauthorized. Please make sure you provide a valid API key.' do
        let("X-Osuny-Token") { 'fake-token' }
        run_test!
      end

      response '404', 'Website not found' do
        let(:website_id) { 'fake-id' }
        run_test!
      end

      response '404', 'Page not found' do
        let(:id) { 'fake-id' }
        run_test!
      end

      response '422', 'Invalid parameters' do
        let(:communication_website_page) {
          test_page = communication_website_pages(:test_page)
          test_page_l10n = communication_website_page_localizations(:test_page_fr)
          {
            page: {
              migration_identifier: test_page.migration_identifier,
              parent_id: test_page.parent_id,
              full_width: test_page.full_width,
              category_ids: test_page.category_ids,
              localizations: {
                test_page_l10n.language.iso_code => {
                  migration_identifier: test_page_l10n.migration_identifier,
                  title: nil,
                  breadcrumb_title: test_page_l10n.breadcrumb_title,
                  meta_description: test_page_l10n.meta_description,
                  published: test_page_l10n.published,
                  published_at: test_page_l10n.published_at,
                  slug: test_page_l10n.slug,
                  summary: test_page_l10n.summary,
                  header_text: test_page_l10n.header_text,
                  header_cta: test_page_l10n.header_cta,
                  header_cta_label: test_page_l10n.header_cta_label,
                  header_cta_url: test_page_l10n.header_cta_url
                }
              }
            }
          }
        }
        run_test!
      end
    end

    delete 'Deletes a page' do
      tags 'Communication::Website::Page'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }
      parameter name: :id, in: :path, type: :string, description: 'Page identifier'
      let(:id) { communication_website_pages(:test_page).id }

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

      response '404', 'Page not found' do
        let(:id) { 'fake-id' }
        run_test!
      end
    end
  end
end
