require 'swagger_helper'

RSpec.describe 'University::Organization::Category' do
  fixtures :all

  path '/university/organizations/categories' do
    get "Lists organization categories" do
      tags 'University::Organization::Category'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      response '200', 'Successful operation' do
        schema type: :array, items: { '$ref' => '#/components/schemas/university_organization_category' }
        run_test!
      end

      response '401', 'Unauthorized. Please make sure you provide a valid API key.' do
        let("X-Osuny-Token") { 'fake-token' }
        run_test!
      end
    end

    post 'Creates a organization category' do
      tags 'University::Organization::Category'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :university_organization_category, in: :body, type: :object, schema: {
        type: :object,
        properties: {
          category: {
            '$ref': '#/components/schemas/university_organization_category'
          }
        },
        required: [:category]
      }
      let(:university_organization_category) {
        {
          category: {
            migration_identifier: 'organization-category-from-api-1',
            localizations: {
              fr: {
                migration_identifier: 'organization-category-from-api-1-fr',
                name: 'Ma nouvelle catégorie',
                meta_description: 'Une nouvelle catégorie depuis l\'API',
                featured_image: {
                  url: 'https://images.unsplash.com/photo-1703923633616-254e78f6e9df?q=80&w=2070&auto=format&fit=crop',
                  alt: 'La lumière brille sur les parois du canyon',
                  credit: 'Photo de <a href="https://unsplash.com/fr/@johnnzhou">John Zhou</a> sur <a href="https://unsplash.com/fr/photos/la-lumiere-brille-sur-les-parois-du-canyon-AM-G-Yp5hIk">Unsplash</a>'
                },
                slug: 'ma-nouvelle-categorie',
                summary: 'Ceci est une nouvelle catégorie créée depuis l\'API.',
                blocks: [
                  {
                    migration_identifier: 'organization-category-from-api-1-fr-block-1',
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
        it 'creates a organization category and its localization', rswag: true do |example|
          assert_difference ->{ University::Organization::Category.count } => 1, ->{ University::Organization::Category::Localization.count } => 1 do
            assert_enqueued_jobs 1, only: Api::AttachFeaturedImageFromUrlJob do
              submit_request(example.metadata)
              assert_response_matches_metadata(example.metadata)
            end
          end
        end
      end

      response '400', 'Missing migration identifier.' do
        let(:university_organization_category) {
          {
            category: {
              localizations: {
                fr: {
                  migration_identifier: 'organization-category-from-api-1-fr',
                  name: 'Ma nouvelle catégorie',
                  meta_description: 'Une nouvelle catégorie depuis l\'API',
                  slug: 'ma-nouvelle-categorie',
                  summary: 'Ceci est une nouvelle catégorie créée depuis l\'API.'
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

      response '422', 'Invalid parameters' do
        let(:university_organization_category) {
          {
            category: {
              migration_identifier: 'organization-category-from-api-1',
              localizations: {
                fr: {
                  migration_identifier: 'organization-category-from-api-1-fr',
                  meta_description: 'Une nouvelle catégorie depuis l\'API',
                  summary: 'Ceci est une nouvelle catégorie créée depuis l\'API.'
                }
              }
            }
          }
        }
        run_test!
      end
    end
  end

  path '/university/organizations/categories/upsert' do
    post 'Upsert organization categories' do
      tags 'University::Organization::Category'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :categories, in: :body, type: :object, schema: {
        type: :object,
        properties: {
          categories: {
            type: :array,
            items: {
              '$ref': '#/components/schemas/university_organization_category'
            }
          }
        },
        required: [:categories]
      }
      let(:categories) {
        test_category = university_organization_categories(:test_category)
        test_category_l10n = university_organization_category_localizations(:test_category_fr)
        {
          categories: [
            {
              migration_identifier: 'organization-category-from-api-1',
              localizations: {
                fr: {
                  migration_identifier: 'organization-category-from-api-1-fr',
                  name: 'Ma nouvelle catégorie',
                  meta_description: 'Une nouvelle catégorie depuis l\'API',
                  featured_image: {
                    url: 'https://images.unsplash.com/photo-1703923633616-254e78f6e9df?q=80&w=2070&auto=format&fit=crop',
                    alt: 'La lumière brille sur les parois du canyon',
                    credit: 'Photo de <a href="https://unsplash.com/fr/@johnnzhou">John Zhou</a> sur <a href="https://unsplash.com/fr/photos/la-lumiere-brille-sur-les-parois-du-canyon-AM-G-Yp5hIk">Unsplash</a>'
                  },
                  slug: 'ma-nouvelle-categorie',
                  summary: 'Ceci est une nouvelle catégorie créée depuis l\'API.',
                  blocks: [
                    {
                      migration_identifier: 'organization-category-from-api-1-fr-block-1',
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
              migration_identifier: test_category.migration_identifier,
              parent_id: test_category.parent_id,
              position: test_category.position,
              is_taxonomy: test_category.is_taxonomy,
              localizations: {
                test_category_l10n.language.iso_code => {
                  migration_identifier: test_category_l10n.migration_identifier,
                  name: "Mon nouveau nom",
                  meta_description: test_category_l10n.meta_description,
                  slug: test_category_l10n.slug,
                  summary: test_category_l10n.summary
                }
              }
            }
          ]
        }
      }

      response '200', 'Successful upsertion' do
        it 'creates a organization category and updates another with their localizations', rswag: true do |example|
          assert_difference ->{ University::Organization::Category.count } => 1, ->{ University::Organization::Category::Localization.count } => 1 do
            assert_enqueued_jobs 1, only: Api::AttachFeaturedImageFromUrlJob do
              submit_request(example.metadata)
              assert_response_matches_metadata(example.metadata)
            end
          end
        end
      end

      response '400', 'Missing migration identifier.' do
        let(:categories) {
          test_category = university_organization_categories(:test_category)
          test_category_l10n = university_organization_category_localizations(:test_category_fr)
          {
            categories: [
              {
                localizations: {
                  fr: {
                    migration_identifier: 'organization-category-from-api-1-fr',
                    name: 'Ma nouvelle catégorie',
                    meta_description: 'Une nouvelle catégorie depuis l\'API',
                    featured_image: {
                      url: 'https://images.unsplash.com/photo-1703923633616-254e78f6e9df?q=80&w=2070&auto=format&fit=crop',
                      alt: 'La lumière brille sur les parois du canyon',
                      credit: 'Photo de <a href="https://unsplash.com/fr/@johnnzhou">John Zhou</a> sur <a href="https://unsplash.com/fr/photos/la-lumiere-brille-sur-les-parois-du-canyon-AM-G-Yp5hIk">Unsplash</a>'
                    },
                    slug: 'ma-nouvelle-categorie',
                    summary: 'Ceci est une nouvelle catégorie créée depuis l\'API.'
                  }
                }
              },
              {
                parent_id: test_category.parent_id,
                position: test_category.position,
                is_taxonomy: test_category.is_taxonomy,
                localizations: {
                  test_category_l10n.language.iso_code => {
                    migration_identifier: test_category_l10n.migration_identifier,
                    name: "Mon nouveau nom",
                    meta_description: test_category_l10n.meta_description,
                    slug: test_category_l10n.slug,
                    summary: test_category_l10n.summary
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

      response '422', 'Invalid parameters' do
        let(:categories) {
          test_category = university_organization_categories(:test_category)
          test_category_l10n = university_organization_category_localizations(:test_category_fr)
          {
            categories: [
              {
                migration_identifier: 'organization-category-from-api-1',
                localizations: {
                  fr: {
                    migration_identifier: 'organization-category-from-api-1-fr',
                    name: nil,
                    meta_description: 'Une nouvelle catégorie depuis l\'API',
                    summary: 'Ceci est une nouvelle catégorie créée depuis l\'API.'
                  }
                }
              },
              {
                migration_identifier: test_category.migration_identifier,
                parent_id: test_category.parent_id,
                position: test_category.position,
                is_taxonomy: test_category.is_taxonomy,
                localizations: {
                  test_category_l10n.language.iso_code => {
                    migration_identifier: test_category_l10n.migration_identifier,
                    name: nil,
                    meta_description: test_category_l10n.meta_description,
                    summary: test_category_l10n.summary
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

  path '/university/organizations/categories/{id}' do
    get 'Shows a organization category' do
      tags 'University::Organization::Category'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :id, in: :path, type: :string, description: 'Category identifier'
      let(:id) { university_organization_categories(:test_category).id }

      response '200', 'Successful operation' do
        run_test!
      end

      response '401', 'Unauthorized. Please make sure you provide a valid API key.' do
        let("X-Osuny-Token") { 'fake-token' }
        run_test!
      end

      response '404', 'Category not found' do
        let(:id) { 'fake-id' }
        run_test!
      end
    end

    patch 'Updates a organization category' do
      tags 'University::Organization::Category'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :id, in: :path, type: :string, description: 'Category identifier'
      let(:id) { university_organization_categories(:test_category).id }

      parameter name: :university_organization_category, in: :body, type: :object, schema: {
        type: :object,
        properties: {
          category: {
            '$ref': '#/components/schemas/university_organization_category'
          }
        },
        required: [:category]
      }
      let(:university_organization_category) {
        test_category = university_organization_categories(:test_category)
        test_category_l10n = university_organization_category_localizations(:test_category_fr)
        {
          category: {
            migration_identifier: test_category.migration_identifier,
            parent_id: test_category.parent_id,
            position: test_category.position,
            is_taxonomy: test_category.is_taxonomy,
            localizations: {
              test_category_l10n.language.iso_code => {
                migration_identifier: test_category_l10n.migration_identifier,
                name: "Mon nouveau nom",
                meta_description: test_category_l10n.meta_description,
                slug: test_category_l10n.slug,
                summary: test_category_l10n.summary
              }
            }
          }
        }
      }

      response '200', 'Successful update' do
        run_test! do |response|
          assert_equal("Mon nouveau nom", university_organization_category_localizations(:test_category_fr).reload.name)
        end
      end

      response '400', 'Missing migration identifier.' do
        let(:university_organization_category) {
          test_category = university_organization_categories(:test_category)
          test_category_l10n = university_organization_category_localizations(:test_category_fr)
          {
            category: {
              parent_id: test_category.parent_id,
              position: test_category.position,
              is_taxonomy: test_category.is_taxonomy,
              localizations: {
                test_category_l10n.language.iso_code => {
                  migration_identifier: test_category_l10n.migration_identifier,
                  name: "Mon nouveau nom",
                  meta_description: test_category_l10n.meta_description,
                  slug: test_category_l10n.slug,
                  summary: test_category_l10n.summary
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

      response '404', 'Category not found' do
        let(:id) { 'fake-id' }
        run_test!
      end

      response '422', 'Invalid parameters' do
        let(:university_organization_category) {
          test_category = university_organization_categories(:test_category)
          test_category_l10n = university_organization_category_localizations(:test_category_fr)
          {
            category: {
              migration_identifier: test_category.migration_identifier,
              parent_id: test_category.parent_id,
              position: test_category.position,
              is_taxonomy: test_category.is_taxonomy,
              localizations: {
                test_category_l10n.language.iso_code => {
                  migration_identifier: test_category_l10n.migration_identifier,
                  name: nil,
                  meta_description: test_category_l10n.meta_description,
                  slug: test_category_l10n.slug,
                  summary: test_category_l10n.summary
                }
              }
            }
          }
        }
        run_test!
      end
    end

    delete 'Deletes a organization category' do
      tags 'University::Organization::Category'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :id, in: :path, type: :string, description: 'Category identifier'
      let(:id) { university_organization_categories(:test_category).id }

      response '204', 'Successful deletion' do
        run_test!
      end

      response '401', 'Unauthorized. Please make sure you provide a valid API key.' do
        let("X-Osuny-Token") { 'fake-token' }
        run_test!
      end

      response '404', 'Page not found' do
        let(:id) { 'fake-id' }
        run_test!
      end
    end
  end
end