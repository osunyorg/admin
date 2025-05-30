require 'swagger_helper'

RSpec.describe 'University::Organization' do
  fixtures :all

  path '/university/organizations' do
    get "Lists organizations" do
      tags 'University::Organization'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      response '200', 'Successful operation' do
        schema type: :array, items: { '$ref' => '#/components/schemas/university_organization' }
        run_test!
      end

      response '401', 'Unauthorized. Please make sure you provide a valid API key.' do
        let("X-Osuny-Token") { 'fake-token' }
        run_test!
      end
    end

    post 'Creates a organization' do
      tags 'University::Organization'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :university_organization, in: :body, type: :object, schema: {
        type: :object,
        properties: {
          organization: {
            '$ref': '#/components/schemas/university_organization'
          }
        },
        required: [:organization]
      }
      let(:university_organization) {
        organization_category = university_organization_categories(:test_category)
        {
          organization: {
            migration_identifier: 'organization-from-api-1',
            email: "contact@example.org",
            phone: "+33123456789",
            address: "1 rue de l'organisation",
            zipcode: "75000",
            city: "Paris",
            country: "FR",
            nic: "00001",
            siren: "123456789",
            category_ids: [organization_category.id],
            localizations: {
              fr: {
                migration_identifier: 'organization-from-api-1-fr',
                name: 'Mon organisation',
                long_name: 'Mon organisation ESS',
                meta_description: 'Une organisation de l\'ESS',
                featured_image: {
                  url: 'https://images.unsplash.com/photo-1703923633616-254e78f6e9df?q=80&w=2070&auto=format&fit=crop',
                  alt: 'La lumière brille sur les parois du canyon',
                  credit: 'Photo de <a href="https://unsplash.com/fr/@johnnzhou">John Zhou</a> sur <a href="https://unsplash.com/fr/photos/la-lumiere-brille-sur-les-parois-du-canyon-AM-G-Yp5hIk">Unsplash</a>'
                },
                address_name: 'Siège',
                url: "https://example.org",
                slug: 'mon-organisation',
                blocks: [
                  {
                    migration_identifier: 'organization-from-api-1-fr-block-1',
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
        it 'creates an organization and its localization', rswag: true do |example|
          assert_difference ->{ University::Organization.count } => 1, ->{ University::Organization::Localization.count } => 1 do
            assert_enqueued_jobs 1, only: Api::AttachFeaturedImageFromUrlJob do
              submit_request(example.metadata)
              assert_response_matches_metadata(example.metadata)
            end
          end
        end
      end

      response '400', 'Missing migration identifier.' do
        let(:university_organization) {
          {
            organization: {
              email: "contact@example.org",
              phone: "+33123456789",
              address: "1 rue de l'organisation",
              zipcode: "75000",
              city: "Paris",
              country: "FR",
              nic: "00001",
              siren: "123456789",
              localizations: {
                fr: {
                  migration_identifier: 'organization-from-api-1-fr',
                  name: 'Mon organisation',
                  long_name: 'Mon organisation ESS',
                  meta_description: 'Une organisation de l\'ESS',
                  address_name: 'Siège',
                  url: "https://example.org",
                  slug: 'mon-organisation'
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
        let(:university_organization) {
          {
            organization: {
              migration_identifier: 'organization-from-api-1',
              email: "contact@example.org",
              phone: "+33123456789",
              address: "1 rue de l'organisation",
              zipcode: "75000",
              city: "Paris",
              country: "FR",
              nic: "00001",
              siren: "123456789",
              localizations: {
                fr: {
                  migration_identifier: 'organization-from-api-1-fr',
                  title: nil,
                  meta_description: 'Une organisation de l\'ESS',
                  address_name: 'Siège',
                  url: "https://example.org"
                }
              }
            }
          }
        }
        run_test!
      end
    end
  end

  path '/university/organizations/upsert' do
    post 'Upsert organizations' do
      tags 'University::Organization'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :organizations, in: :body, type: :object, schema: {
        type: :object,
        properties: {
          organizations: {
            type: :array,
            items: {
              '$ref': '#/components/schemas/university_organization'
            }
          }
        },
        required: [:organizations]
      }
      let(:organizations) {
        noesya = university_organizations(:noesya)
        noesya_l10n = university_organization_localizations(:noesya_fr)
        organization_category = university_organization_categories(:test_category)
        {
          organizations: [
            {
              migration_identifier: 'organization-from-api-1',
              email: "contact@example.org",
              phone: "+33123456789",
              address: "1 rue de l'organisation",
              zipcode: "75000",
              city: "Paris",
              country: "FR",
              nic: "00001",
              siren: "123456789",
              category_ids: [organization_category.id],
              localizations: {
                fr: {
                  migration_identifier: 'organization-from-api-1-fr',
                  name: 'Mon organisation',
                  long_name: 'Mon organisation ESS',
                  meta_description: 'Une organisation de l\'ESS',
                  featured_image: {
                    url: 'https://images.unsplash.com/photo-1703923633616-254e78f6e9df?q=80&w=2070&auto=format&fit=crop',
                    alt: 'La lumière brille sur les parois du canyon',
                    credit: 'Photo de <a href="https://unsplash.com/fr/@johnnzhou">John Zhou</a> sur <a href="https://unsplash.com/fr/photos/la-lumiere-brille-sur-les-parois-du-canyon-AM-G-Yp5hIk">Unsplash</a>'
                  },
                  address_name: 'Siège',
                  url: "https://example.org",
                  slug: 'mon-organisation',
                  blocks: [
                    {
                      migration_identifier: 'organization-from-api-1-fr-block-1',
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
              migration_identifier: noesya.migration_identifier,
              kind: noesya.kind,
              email: noesya.email,
              phone: noesya.phone,
              address: noesya.address,
              zipcode: noesya.zipcode,
              city: noesya.city,
              country: noesya.country,
              nic: noesya.nic,
              siren: noesya.siren,
              category_ids: noesya.category_ids,
              localizations: {
                noesya_l10n.language.iso_code => {
                  migration_identifier: noesya_l10n.migration_identifier,
                  name: 'noesya (new)',
                  long_name: noesya_l10n.long_name,
                  meta_description: noesya_l10n.meta_description,
                  address_name: noesya_l10n.address_name,
                  linkedin: noesya_l10n.linkedin,
                  url: noesya_l10n.url,
                  slug: noesya_l10n.slug,
                  summary: noesya_l10n.summary
                }
              }
            }
          ]
        }
      }

      response '200', 'Successful upsertion' do
        it 'creates an organization and updates another with their localizations', rswag: true do |example|
          assert_difference ->{ University::Organization.count } => 1, ->{ University::Organization::Localization.count } => 1 do
            assert_enqueued_jobs 1, only: Api::AttachFeaturedImageFromUrlJob do
              submit_request(example.metadata)
              assert_response_matches_metadata(example.metadata)
            end
          end
        end
      end

      response '400', 'Missing migration identifier.' do
        let(:organizations) {
          noesya = university_organizations(:noesya)
          noesya_l10n = university_organization_localizations(:noesya_fr)
          {
            organizations: [
              {
                migration_identifier: 'organization-from-api-1',
                email: "contact@example.org",
                phone: "+33123456789",
                address: "1 rue de l'organisation",
                zipcode: "75000",
                city: "Paris",
                country: "FR",
                nic: "00001",
                siren: "123456789",
                localizations: {
                  fr: {
                    migration_identifier: 'organization-from-api-1-fr',
                    name: 'Mon organisation',
                    long_name: 'Mon organisation ESS',
                    meta_description: 'Une organisation de l\'ESS',
                    featured_image: {
                      url: 'https://images.unsplash.com/photo-1703923633616-254e78f6e9df?q=80&w=2070&auto=format&fit=crop',
                      alt: 'La lumière brille sur les parois du canyon',
                      credit: 'Photo de <a href="https://unsplash.com/fr/@johnnzhou">John Zhou</a> sur <a href="https://unsplash.com/fr/photos/la-lumiere-brille-sur-les-parois-du-canyon-AM-G-Yp5hIk">Unsplash</a>'
                    },
                    address_name: 'Siège',
                    url: "https://example.org",
                    slug: 'mon-organisation',
                    blocks: [
                      {
                        migration_identifier: 'organization-from-api-1-fr-block-1',
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
                kind: noesya.kind,
                email: noesya.email,
                phone: noesya.phone,
                address: noesya.address,
                zipcode: noesya.zipcode,
                city: noesya.city,
                country: noesya.country,
                nic: noesya.nic,
                siren: noesya.siren,
                localizations: {
                  noesya_l10n.language.iso_code => {
                    migration_identifier: noesya_l10n.migration_identifier,
                    name: 'noesya (new)',
                    long_name: noesya_l10n.long_name,
                    meta_description: noesya_l10n.meta_description,
                    address_name: noesya_l10n.address_name,
                    linkedin: noesya_l10n.linkedin,
                    url: noesya_l10n.url,
                    slug: noesya_l10n.slug,
                    summary: noesya_l10n.summary
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
        let(:organizations) {
          noesya = university_organizations(:noesya)
          noesya_l10n = university_organization_localizations(:noesya_fr)
          {
            organizations: [
              {
                migration_identifier: 'organization-from-api-1',
                email: "contact@example.org",
                phone: "+33123456789",
                address: "1 rue de l'organisation",
                zipcode: "75000",
                city: "Paris",
                country: "FR",
                nic: "00001",
                siren: "123456789",
                localizations: {
                  fr: {
                    migration_identifier: 'organization-from-api-1-fr',
                    name: nil
                  }
                }
              },
              {
                migration_identifier: noesya.migration_identifier,
                kind: noesya.kind,
                email: noesya.email,
                phone: noesya.phone,
                address: noesya.address,
                zipcode: noesya.zipcode,
                city: noesya.city,
                country: noesya.country,
                nic: noesya.nic,
                siren: noesya.siren,
                localizations: {
                  noesya_l10n.language.iso_code => {
                    migration_identifier: noesya_l10n.migration_identifier,
                    name: nil
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

  path '/university/organizations/{id}' do
    get 'Shows an organization' do
      tags 'University::Organization'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :id, in: :path, type: :string, description: 'Organization identifier'
      let(:id) { university_organizations(:noesya).id }

      response '200', 'Successful operation' do
        run_test!
      end

      response '401', 'Unauthorized. Please make sure you provide a valid API key.' do
        let("X-Osuny-Token") { 'fake-token' }
        run_test!
      end

      response '404', 'Organization not found' do
        let(:id) { 'fake-id' }
        run_test!
      end
    end

    patch 'Updates an organization' do
      tags 'University::Organization'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :id, in: :path, type: :string, description: 'Organization identifier'
      let(:id) { university_organizations(:noesya).id }

      parameter name: :university_organization, in: :body, type: :object, schema: {
        type: :object,
        properties: {
          organization: {
            '$ref': '#/components/schemas/university_organization'
          }
        },
        required: [:organization]
      }
      let(:university_organization) {
        noesya = university_organizations(:noesya)
        noesya_l10n = university_organization_localizations(:noesya_fr)
        {
          organization: {
            migration_identifier: noesya.migration_identifier,
            kind: noesya.kind,
            email: noesya.email,
            phone: noesya.phone,
            address: noesya.address,
            zipcode: noesya.zipcode,
            city: noesya.city,
            country: noesya.country,
            nic: noesya.nic,
            siren: noesya.siren,
            localizations: {
              noesya_l10n.language.iso_code => {
                migration_identifier: noesya_l10n.migration_identifier,
                name: 'noesya (new)',
                long_name: noesya_l10n.long_name,
                meta_description: noesya_l10n.meta_description,
                address_name: noesya_l10n.address_name,
                linkedin: noesya_l10n.linkedin,
                url: noesya_l10n.url,
                slug: noesya_l10n.slug,
                summary: noesya_l10n.summary
              }
            }
          }
        }
      }

      response '200', 'Successful update' do
        run_test! do |response|
          assert_equal("noesya (new)", university_organization_localizations(:noesya_fr).reload.name)
        end
      end

      response '400', 'Missing migration identifier.' do
        let(:university_organization) {
          noesya = university_organizations(:noesya)
          noesya_l10n = university_organization_localizations(:noesya_fr)
          {
            organization: {
              kind: noesya.kind,
              email: noesya.email,
              phone: noesya.phone,
              address: noesya.address,
              zipcode: noesya.zipcode,
              city: noesya.city,
              country: noesya.country,
              nic: noesya.nic,
              siren: noesya.siren,
              localizations: {
                noesya_l10n.language.iso_code => {
                  migration_identifier: noesya_l10n.migration_identifier,
                  name: 'noesya (new)',
                  long_name: noesya_l10n.long_name,
                  meta_description: noesya_l10n.meta_description,
                  address_name: noesya_l10n.address_name,
                  linkedin: noesya_l10n.linkedin,
                  url: noesya_l10n.url,
                  slug: noesya_l10n.slug,
                  summary: noesya_l10n.summary
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

      response '404', 'Post not found' do
        let(:id) { 'fake-id' }
        run_test!
      end

      response '422', 'Invalid parameters' do
        let(:university_organization) {
          noesya = university_organizations(:noesya)
          noesya_l10n = university_organization_localizations(:noesya_fr)
          {
            organization: {
              migration_identifier: noesya.migration_identifier,
              kind: noesya.kind,
              email: noesya.email,
              phone: noesya.phone,
              address: noesya.address,
              zipcode: noesya.zipcode,
              city: noesya.city,
              country: noesya.country,
              nic: noesya.nic,
              siren: noesya.siren,
              localizations: {
                noesya_l10n.language.iso_code => {
                  migration_identifier: noesya_l10n.migration_identifier,
                  name: nil,
                  long_name: noesya_l10n.long_name,
                  meta_description: noesya_l10n.meta_description,
                  address_name: noesya_l10n.address_name,
                  linkedin: noesya_l10n.linkedin,
                  url: noesya_l10n.url,
                  slug: noesya_l10n.slug,
                  summary: noesya_l10n.summary
                }
              }
            }
          }
        }
        run_test!
      end
    end

    delete 'Deletes an organization' do
      tags 'University::Organization'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :id, in: :path, type: :string, description: 'Organization identifier'
      let(:id) { university_organizations(:noesya).id }

      response '204', 'Successful deletion' do
        run_test!
      end

      response '401', 'Unauthorized. Please make sure you provide a valid API key.' do
        let("X-Osuny-Token") { 'fake-token' }
        run_test!
      end

      response '404', 'Organization not found' do
        let(:id) { 'fake-id' }
        run_test!
      end
    end
  end
end
