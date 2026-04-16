require 'swagger_helper'

RSpec.describe 'Communication::Website::Portfolio::Project' do
  fixtures :all

  path '/communication/websites/{website_id}/portfolio/projects' do
    get "Lists a website's projects" do
      tags 'Communication::Website::Portfolio::Project'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :page_num, in: :query, schema: { type: :integer, default: 1 }, description: 'Page number', required: false
      parameter name: :per_page, in: :query, schema: { type: :integer, default: 10000, maximum: 10000 }, description: 'Number of items per page', required: false

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }

      response '200', 'Successful operation' do
        schema type: :array, items: { '$ref' => '#/components/schemas/communication_website_portfolio_project' }
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

    post 'Creates a project' do
      tags 'Communication::Website::Portfolio::Project'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }

      parameter name: :communication_website_portfolio_project, in: :body, type: :object, schema: {
        type: :object,
        properties: {
          project: {
            '$ref': '#/components/schemas/communication_website_portfolio_project'
          }
        },
        required: [:project]
      }
      let(:communication_website_portfolio_project) {
        portfolio_category = communication_website_portfolio_categories(:test_category)
        {
          project: {
            migration_identifier: 'project-from-api-1',
            full_width: false,
            category_ids: [portfolio_category.id],
            year: 2026,
            localizations: {
              fr: {
                migration_identifier: 'project-from-api-1-fr',
                title: 'Mon nouveau projet',
                meta_description: 'Un nouveau projet depuis l\'API',
                featured_image: {
                  url: 'https://images.unsplash.com/photo-1703923633616-254e78f6e9df?q=80&w=2070&auto=format&fit=crop',
                  alt: 'La lumière brille sur les parois du canyon',
                  credit: 'Photo de <a href="https://unsplash.com/fr/@johnnzhou">John Zhou</a> sur <a href="https://unsplash.com/fr/photos/la-lumiere-brille-sur-les-parois-du-canyon-AM-G-Yp5hIk">Unsplash</a>'
                },
                published: true,
                published_at: '2024-11-29T16:49:00Z',
                slug: 'mon-nouveau-projet',
                subtitle: 'Un nouveau projet',
                summary: 'Ceci est un nouveau projet créé depuis l\'API.',
                aliases: [
                  { path: "/nouveau-projet" }
                ],
                blocks: [
                  {
                    migration_identifier: 'project-from-api-1-fr-block-1',
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
        it 'creates a project and its localization', rswag: true do |example|
          assert_difference ->{ Communication::Website::Portfolio::Project.count } => 1,
                            ->{ Communication::Website::Portfolio::Project::Localization.count } => 1,
                            ->{ Communication::Website::Permalink.count } => 1 do
            assert_enqueued_jobs 1, only: Api::AttachFeaturedImageFromUrlJob do
              submit_request(example.metadata)
              assert_response_matches_metadata(example.metadata)
            end
          end
        end
      end

      response '400', 'Missing migration identifier.' do
        let(:communication_website_portfolio_project) {
          {
            project: {
              full_width: false,
              year: 2026,
              localizations: {
                fr: {
                  migration_identifier: 'project-from-api-1-fr',
                  title: 'Mon nouveau projet',
                  meta_description: 'Un nouveau projet depuis l\'API',
                  published: true,
                  published_at: '2024-11-29T16:49:00Z',
                  slug: 'mon-nouveau-projet',
                  subtitle: 'Un nouveau projet',
                  summary: 'Ceci est un nouveau projet créé depuis l\'API.'
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
        let(:communication_website_portfolio_project) {
          {
            project: {
              migration_identifier: 'project-from-api-1',
              full_width: false,
              localizations: {
                fr: {
                  migration_identifier: 'project-from-api-1-fr',
                  title: nil
                }
              }
            }
          }
        }
        run_test!
      end
    end
  end

  path '/communication/websites/{website_id}/portfolio/projects/upsert' do
    post 'Upsert projects' do
      tags 'Communication::Website::Portfolio::Project'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }

      parameter name: :projects, in: :body, type: :object, schema: {
        type: :object,
        properties: {
          projects: {
            type: :array,
            items: {
              '$ref': '#/components/schemas/communication_website_portfolio_project'
            }
          }
        },
        required: [:projects]
      }
      let(:projects) {
        test_project = communication_website_portfolio_projects(:test_project)
        test_project_l10n = communication_website_portfolio_project_localizations(:test_project_fr)
        project_category = communication_website_portfolio_categories(:test_category)
        {
          projects: [
            {
              migration_identifier: 'project-from-api-1',
              full_width: false,
              category_ids: [project_category.id],
              year: 2026,
              localizations: {
                fr: {
                  migration_identifier: 'project-from-api-1-fr',
                  title: 'Mon nouveau projet',
                  meta_description: 'Un nouveau projet depuis l\'API',
                  featured_image: {
                    url: 'https://images.unsplash.com/photo-1703923633616-254e78f6e9df?q=80&w=2070&auto=format&fit=crop',
                    alt: 'La lumière brille sur les parois du canyon',
                    credit: 'Photo de <a href="https://unsplash.com/fr/@johnnzhou">John Zhou</a> sur <a href="https://unsplash.com/fr/photos/la-lumiere-brille-sur-les-parois-du-canyon-AM-G-Yp5hIk">Unsplash</a>'
                  },
                  published: true,
                  published_at: '2024-11-29T16:49:00Z',
                  slug: 'mon-nouveau-projet',
                  subtitle: 'Un nouveau projet',
                  summary: 'Ceci est un nouveau projet créé depuis l\'API.',
                  blocks: [
                    {
                      migration_identifier: 'project-from-api-1-fr-block-1',
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
              migration_identifier: test_project.migration_identifier,
              full_width: test_project.full_width,
              category_ids: test_project.category_ids,
              year: test_project.year,
              localizations: {
                test_project_l10n.language.iso_code => {
                  migration_identifier: test_project_l10n.migration_identifier,
                  title: "Mon nouveau titre",
                  meta_description: test_project_l10n.meta_description,
                  published: test_project_l10n.published,
                  published_at: test_project_l10n.published_at,
                  slug: test_project_l10n.slug,
                  subtitle: test_project_l10n.subtitle,
                  summary: test_project_l10n.summary
                }
              }
            }
          ]
        }
      }

      response '200', 'Successful upsertion' do
        it 'creates a project and updates another with their localizations', rswag: true do |example|
          assert_difference ->{ Communication::Website::Portfolio::Project.count } => 1, ->{ Communication::Website::Portfolio::Project::Localization.count } => 1 do
            assert_enqueued_jobs 1, only: Api::AttachFeaturedImageFromUrlJob do
              submit_request(example.metadata)
              assert_response_matches_metadata(example.metadata)
            end
          end
        end
      end

      response '400', 'Missing migration identifier.' do
        let(:projects) {
          test_project = communication_website_portfolio_projects(:test_project)
          test_project_l10n = communication_website_portfolio_project_localizations(:test_project_fr)
          {
            projects: [
              {
                migration_identifier: 'project-from-api-1',
                full_width: false,
                year: 2026,
                localizations: {
                  fr: {
                    title: 'Mon nouveau projet',
                    meta_description: 'Un nouveau projet depuis l\'API',
                    featured_image: {
                      url: 'https://images.unsplash.com/photo-1703923633616-254e78f6e9df?q=80&w=2070&auto=format&fit=crop',
                      alt: 'La lumière brille sur les parois du canyon',
                      credit: 'Photo de <a href="https://unsplash.com/fr/@johnnzhou">John Zhou</a> sur <a href="https://unsplash.com/fr/photos/la-lumiere-brille-sur-les-parois-du-canyon-AM-G-Yp5hIk">Unsplash</a>'
                    },
                    published: true,
                    published_at: '2024-11-29T16:49:00Z',
                    slug: 'mon-nouveau-projet',
                    subtitle: 'Un nouveau projet',
                    summary: 'Ceci est un nouveau projet créé depuis l\'API.',
                    blocks: [
                      {
                        migration_identifier: 'project-from-api-1-fr-block-1',
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
                full_width: test_project.full_width,
                year: test_project.year,
                localizations: {
                  test_project_l10n.language.iso_code => {
                    migration_identifier: test_project_l10n.migration_identifier,
                    title: "Mon nouveau titre",
                    meta_description: test_project_l10n.meta_description,
                    published: test_project_l10n.published,
                    published_at: test_project_l10n.published_at,
                    slug: test_project_l10n.slug,
                    subtitle: test_project_l10n.subtitle,
                    summary: test_project_l10n.summary
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
        let(:projects) {
          test_project = communication_website_portfolio_projects(:test_project)
          test_project_l10n = communication_website_portfolio_project_localizations(:test_project_fr)
          {
            projects: [
              {
                migration_identifier: 'project-from-api-1',
                full_width: false,
                year: 2026,
                localizations: {
                  fr: {
                    migration_identifier: 'project-from-api-1-fr',
                    title: nil
                  }
                }
              },
              {
                migration_identifier: test_project.migration_identifier,
                full_width: test_project.full_width,
                year: test_project.year,
                localizations: {
                  test_project_l10n.language.iso_code => {
                    migration_identifier: test_project_l10n.migration_identifier,
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

  path '/communication/websites/{website_id}/portfolio/projects/{id}' do
    get 'Shows a project' do
      tags 'Communication::Website::Portfolio::Project'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }
      parameter name: :id, in: :path, type: :string, description: 'Project identifier'
      let(:id) { communication_website_portfolio_projects(:test_project).id }

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

      response '404', 'Project not found' do
        let(:id) { 'fake-id' }
        run_test!
      end
    end

    patch 'Updates a project' do
      tags 'Communication::Website::Portfolio::Project'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }
      parameter name: :id, in: :path, type: :string, description: 'Project identifier'
      let(:id) { communication_website_portfolio_projects(:test_project).id }

      parameter name: :communication_website_portfolio_project, in: :body, type: :object, schema: {
        type: :object,
        properties: {
          project: {
            '$ref': '#/components/schemas/communication_website_portfolio_project'
          }
        },
        required: [:project]
      }
      let(:communication_website_portfolio_project) {
        test_project = communication_website_portfolio_projects(:test_project)
        test_project_l10n = communication_website_portfolio_project_localizations(:test_project_fr)
        {
          project: {
            migration_identifier: test_project.migration_identifier,
            full_width: test_project.full_width,
            category_ids: test_project.category_ids,
            year: test_project.year,
            localizations: {
              test_project_l10n.language.iso_code => {
                migration_identifier: test_project_l10n.migration_identifier,
                title: "Mon nouveau titre",
                meta_description: test_project_l10n.meta_description,
                published: test_project_l10n.published,
                published_at: test_project_l10n.published_at,
                slug: test_project_l10n.slug,
                subtitle: test_project_l10n.subtitle,
                summary: test_project_l10n.summary
              }
            }
          }
        }
      }

      response '200', 'Successful update' do
        run_test! do |response|
          assert_equal("Mon nouveau titre", communication_website_portfolio_project_localizations(:test_project_fr).reload.title)
        end
      end

      response '400', 'Missing migration identifier.' do
        let(:communication_website_portfolio_project) {
          test_project = communication_website_portfolio_projects(:test_project)
          test_project_l10n = communication_website_portfolio_project_localizations(:test_project_fr)
          {
            project: {
              full_width: test_project.full_width,
              category_ids: test_project.category_ids,
              year: test_project.year,
              localizations: {
                test_project_l10n.language.iso_code => {
                  migration_identifier: test_project_l10n.migration_identifier,
                  title: test_project_l10n.title,
                  meta_description: test_project_l10n.meta_description,
                  published: test_project_l10n.published,
                  published_at: test_project_l10n.published_at,
                  slug: test_project_l10n.slug,
                  subtitle: test_project_l10n.subtitle,
                  summary: test_project_l10n.summary
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

      response '404', 'Project not found' do
        let(:id) { 'fake-id' }
        run_test!
      end

      response '422', 'Invalid parameters' do
        let(:communication_website_portfolio_project) {
          test_project = communication_website_portfolio_projects(:test_project)
          test_project_l10n = communication_website_portfolio_project_localizations(:test_project_fr)
          {
            project: {
              migration_identifier: test_project.migration_identifier,
              full_width: test_project.full_width,
              category_ids: test_project.category_ids,
              year: test_project.year,
              localizations: {
                test_project_l10n.language.iso_code => {
                  migration_identifier: test_project_l10n.migration_identifier,
                  title: nil,
                  meta_description: test_project_l10n.meta_description,
                  published: test_project_l10n.published,
                  published_at: test_project_l10n.published_at,
                  slug: test_project_l10n.slug,
                  subtitle: test_project_l10n.subtitle,
                  summary: test_project_l10n.summary
                }
              }
            }
          }
        }
        run_test!
      end
    end

    delete 'Deletes a project' do
      tags 'Communication::Website::Portfolio::Project'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }
      parameter name: :id, in: :path, type: :string, description: 'Project identifier'
      let(:id) { communication_website_portfolio_projects(:test_project).id }

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

      response '404', 'Project not found' do
        let(:id) { 'fake-id' }
        run_test!
      end
    end
  end
end
