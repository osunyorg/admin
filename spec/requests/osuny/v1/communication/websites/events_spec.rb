require 'swagger_helper'

RSpec.describe 'Communication::Website::Agenda::Event' do
  fixtures :all

  path '/communication/websites/{website_id}/agenda/events' do
    get "Lists a website's events" do
      tags 'Communication::Website::Agenda::Event'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }

      response '200', 'Successful operation' do
        schema type: :array, items: { '$ref' => '#/components/schemas/communication_website_agenda_event' }
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

    post 'Creates an event' do
      tags 'Communication::Website::Agenda::Event'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }

      parameter name: :communication_website_agenda_event, in: :body, type: :object, schema: {
        type: :object,
        properties: {
          event: {
            '$ref': '#/components/schemas/communication_website_agenda_event'
          }
        },
        required: [:event]
      }
      let(:communication_website_agenda_event) {
        {
          event: {
            migration_identifier: 'event-from-api-1',
            from_day: '2024-12-24',
            from_hour: '19:00',
            to_day: '2024-12-25',
            to_hour: '14:00',
            time_zone: 'Europe/Paris',
            localizations: {
              fr: {
                migration_identifier: 'event-from-api-1-fr',
                title: 'Noël',
                meta_description: 'Les repas de Noël',
                featured_image: {
                  url: 'https://images.unsplash.com/photo-1703923633616-254e78f6e9df?q=80&w=2070&auto=format&fit=crop',
                  alt: 'La lumière brille sur les parois du canyon',
                  credit: 'Photo de <a href="https://unsplash.com/fr/@johnnzhou">John Zhou</a> sur <a href="https://unsplash.com/fr/photos/la-lumiere-brille-sur-les-parois-du-canyon-AM-G-Yp5hIk">Unsplash</a>'
                },
                published: true,
                published_at: '2024-12-20T06:47:00Z',
                slug: 'noel',
                subtitle: 'Les repas de Noël',
                summary: 'Les repas de Noël en famille.',
                blocks: [
                  {
                    migration_identifier: 'event-from-api-1-fr-block-1',
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
        it 'creates an event and its localization', rswag: true, vcr: true do |example|
          assert_difference ->{ Communication::Website::Agenda::Event.count } => 1, ->{ Communication::Website::Agenda::Event::Localization.count } => 1 do
            submit_request(example.metadata)
            assert_response_matches_metadata(example.metadata)
          end
        end
      end

      response '400', 'Missing migration identifier.' do
        let(:communication_website_agenda_event) {
          {
            event: {
              from_day: '2024-12-24',
              from_hour: '19:00',
              to_day: '2024-12-25',
              to_hour: '14:00',
              time_zone: 'Europe/Paris',
              localizations: {
                fr: {
                  migration_identifier: 'event-from-api-1-fr',
                  title: 'Noël',
                  meta_description: 'Les repas de Noël',
                  published: true,
                  published_at: '2024-12-20T06:47:00Z',
                  slug: 'noel',
                  subtitle: 'Les repas de Noël',
                  summary: 'Les repas de Noël en famille.'
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
        let(:communication_website_agenda_event) {
          {
            event: {
              migration_identifier: 'event-from-api-1',
              from_day: '2024-12-24',
              from_hour: '19:00',
              to_day: '2024-12-25',
              to_hour: '14:00',
              time_zone: 'Europe/Paris',
              localizations: {
                fr: {
                  migration_identifier: 'event-from-api-1-fr',
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

  path '/communication/websites/{website_id}/agenda/events/upsert' do
    post 'Upsert events' do
      tags 'Communication::Website::Agenda::Event'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }

      parameter name: :events, in: :body, type: :object, schema: {
        type: :object,
        properties: {
          events: {
            type: :array,
            items: {
              '$ref': '#/components/schemas/communication_website_agenda_event'
            }
          }
        },
        required: [:events]
      }
      let(:events) {
        test_event = communication_website_agenda_events(:test_event)
        test_event_l10n = communication_website_agenda_event_localizations(:test_event_fr)
        {
          events: [
            {
              migration_identifier: 'event-from-api-1',
              from_day: '2024-12-24',
              from_hour: '19:00',
              to_day: '2024-12-25',
              to_hour: '14:00',
              time_zone: 'Europe/Paris',
              localizations: {
                fr: {
                  migration_identifier: 'event-from-api-1-fr',
                  title: 'Noël',
                  meta_description: 'Les repas de Noël',
                  featured_image: {
                    url: 'https://images.unsplash.com/photo-1703923633616-254e78f6e9df?q=80&w=2070&auto=format&fit=crop',
                    alt: 'La lumière brille sur les parois du canyon',
                    credit: 'Photo de <a href="https://unsplash.com/fr/@johnnzhou">John Zhou</a> sur <a href="https://unsplash.com/fr/photos/la-lumiere-brille-sur-les-parois-du-canyon-AM-G-Yp5hIk">Unsplash</a>'
                  },
                  published: true,
                  published_at: '2024-12-20T06:47:00Z',
                  slug: 'noel',
                  subtitle: 'Les repas de Noël',
                  summary: 'Les repas de Noël en famille.',
                  blocks: [
                    {
                      migration_identifier: 'event-from-api-1-fr-block-1',
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
              migration_identifier: test_event.migration_identifier,
              from_day: test_event.from_day,
              from_hour: test_event.from_hour.strftime("%H:%M"),
              to_day: test_event.to_day,
              to_hour: test_event.to_hour.strftime("%H:%M"),
              time_zone: test_event.time_zone,
              localizations: {
                test_event_l10n.language.iso_code => {
                  migration_identifier: test_event_l10n.migration_identifier,
                  title: "Mon nouveau titre",
                  meta_description: test_event_l10n.meta_description,
                  published: test_event_l10n.published,
                  published_at: test_event_l10n.published_at,
                  slug: test_event_l10n.slug,
                  subtitle: test_event_l10n.subtitle,
                  summary: test_event_l10n.summary
                }
              }
            }
          ]
        }
      }

      response '200', 'Successful upsertion' do
        it 'creates an event and updates another with their localizations', rswag: true, vcr: true do |example|
          assert_difference ->{ Communication::Website::Agenda::Event.count } => 1, ->{ Communication::Website::Agenda::Event::Localization.count } => 1 do
            submit_request(example.metadata)
            assert_response_matches_metadata(example.metadata)
          end
        end
      end

      response '400', 'Missing migration identifier.' do
        let(:events) {
          test_event = communication_website_agenda_events(:test_event)
          test_event_l10n = communication_website_agenda_event_localizations(:test_event_fr)
          {
            events: [
              {
                migration_identifier: 'event-from-api-1',
                from_day: '2024-12-24',
                from_hour: '19:00',
                to_day: '2024-12-25',
                to_hour: '14:00',
                time_zone: 'Europe/Paris',
                localizations: {
                  fr: {
                    migration_identifier: 'event-from-api-1-fr',
                    title: 'Noël',
                    meta_description: 'Les repas de Noël',
                    featured_image: {
                      url: 'https://images.unsplash.com/photo-1703923633616-254e78f6e9df?q=80&w=2070&auto=format&fit=crop',
                      alt: 'La lumière brille sur les parois du canyon',
                      credit: 'Photo de <a href="https://unsplash.com/fr/@johnnzhou">John Zhou</a> sur <a href="https://unsplash.com/fr/photos/la-lumiere-brille-sur-les-parois-du-canyon-AM-G-Yp5hIk">Unsplash</a>'
                    },
                    published: true,
                    published_at: '2024-12-20T06:47:00Z',
                    slug: 'noel',
                    subtitle: 'Les repas de Noël',
                    summary: 'Les repas de Noël en famille.',
                    blocks: [
                      {
                        migration_identifier: 'event-from-api-1-fr-block-1',
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
                from_day: test_event.from_day,
                from_hour: test_event.from_hour.strftime("%H:%M"),
                to_day: test_event.to_day,
                to_hour: test_event.to_hour.strftime("%H:%M"),
                time_zone: test_event.time_zone,
                localizations: {
                  test_event_l10n.language.iso_code => {
                    migration_identifier: test_event_l10n.migration_identifier,
                    title: "Mon nouveau titre",
                    meta_description: test_event_l10n.meta_description,
                    published: test_event_l10n.published,
                    published_at: test_event_l10n.published_at,
                    slug: test_event_l10n.slug,
                    subtitle: test_event_l10n.subtitle,
                    summary: test_event_l10n.summary
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
        let(:events) {
          test_event = communication_website_agenda_events(:test_event)
          test_event_l10n = communication_website_agenda_event_localizations(:test_event_fr)
          {
            events: [
              {
                migration_identifier: 'event-from-api-1',
                from_day: '2024-12-24',
                from_hour: '19:00',
                to_day: '2024-12-25',
                to_hour: '14:00',
                time_zone: 'Europe/Paris',
                localizations: {
                  fr: {
                    migration_identifier: 'event-from-api-1-fr',
                    title: nil
                  }
                }
              },
              {
                migration_identifier: test_event.migration_identifier,
                from_day: test_event.from_day,
                from_hour: test_event.from_hour.strftime("%H:%M"),
                to_day: test_event.to_day,
                to_hour: test_event.to_hour.strftime("%H:%M"),
                time_zone: test_event.time_zone,
                localizations: {
                  test_event_l10n.language.iso_code => {
                    migration_identifier: test_event_l10n.migration_identifier,
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

  path '/communication/websites/{website_id}/agenda/events/{id}' do
    get 'Shows a event' do
      tags 'Communication::Website::Agenda::Event'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }
      parameter name: :id, in: :path, type: :string, description: 'Event identifier'
      let(:id) { communication_website_agenda_events(:test_event).id }

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

      response '404', 'Event not found' do
        let(:id) { 'fake-id' }
        run_test!
      end
    end

    patch 'Updates a event' do
      tags 'Communication::Website::Agenda::Event'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }
      parameter name: :id, in: :path, type: :string, description: 'Event identifier'
      let(:id) { communication_website_agenda_events(:test_event).id }

      parameter name: :communication_website_agenda_event, in: :body, type: :object, schema: {
        type: :object,
        properties: {
          event: {
            '$ref': '#/components/schemas/communication_website_agenda_event'
          }
        },
        required: [:event]
      }
      let(:communication_website_agenda_event) {
        test_event = communication_website_agenda_events(:test_event)
        test_event_l10n = communication_website_agenda_event_localizations(:test_event_fr)
        {
          event: {
            migration_identifier: test_event.migration_identifier,
            from_day: test_event.from_day,
            from_hour: test_event.from_hour.strftime("%H:%M"),
            to_day: test_event.to_day,
            to_hour: test_event.to_hour.strftime("%H:%M"),
            time_zone: test_event.time_zone,
            localizations: {
              test_event_l10n.language.iso_code => {
                migration_identifier: test_event_l10n.migration_identifier,
                title: "Mon nouveau titre",
                meta_description: test_event_l10n.meta_description,
                published: test_event_l10n.published,
                published_at: test_event_l10n.published_at,
                slug: test_event_l10n.slug,
                subtitle: test_event_l10n.subtitle,
                summary: test_event_l10n.summary
              }
            }
          }
        }
      }

      response '200', 'Successful update' do
        run_test! do |response|
          assert_equal("Mon nouveau titre", communication_website_agenda_event_localizations(:test_event_fr).reload.title)
        end
      end

      response '400', 'Missing migration identifier.' do
        let(:communication_website_agenda_event) {
          test_event = communication_website_agenda_events(:test_event)
          test_event_l10n = communication_website_agenda_event_localizations(:test_event_fr)
          {
            event: {
              from_day: test_event.from_day,
              from_hour: test_event.from_hour.strftime("%H:%M"),
              to_day: test_event.to_day,
              to_hour: test_event.to_hour.strftime("%H:%M"),
              time_zone: test_event.time_zone,
              localizations: {
                test_event_l10n.language.iso_code => {
                  migration_identifier: test_event_l10n.migration_identifier,
                  title: "Mon nouveau titre",
                  meta_description: test_event_l10n.meta_description,
                  published: test_event_l10n.published,
                  published_at: test_event_l10n.published_at,
                  slug: test_event_l10n.slug,
                  subtitle: test_event_l10n.subtitle,
                  summary: test_event_l10n.summary
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

      response '404', 'Event not found' do
        let(:id) { 'fake-id' }
        run_test!
      end

      response '422', 'Invalid parameters' do
        let(:communication_website_agenda_event) {
          test_event = communication_website_agenda_events(:test_event)
          test_event_l10n = communication_website_agenda_event_localizations(:test_event_fr)
          {
            event: {
              migration_identifier: test_event.migration_identifier,
              from_day: test_event.from_day,
              from_hour: test_event.from_hour.strftime("%H:%M"),
              to_day: test_event.to_day,
              to_hour: test_event.to_hour.strftime("%H:%M"),
              time_zone: test_event.time_zone,
              localizations: {
                test_event_l10n.language.iso_code => {
                  migration_identifier: test_event_l10n.migration_identifier,
                  title: nil,
                  meta_description: test_event_l10n.meta_description,
                  published: test_event_l10n.published,
                  published_at: test_event_l10n.published_at,
                  slug: test_event_l10n.slug,
                  subtitle: test_event_l10n.subtitle,
                  summary: test_event_l10n.summary
                }
              }
            }
          }
        }
        run_test!
      end
    end

    delete 'Deletes a event' do
      tags 'Communication::Website::Agenda::Event'
      security [{ api_key: [] }]
      let("X-Osuny-Token") { university_apps(:default_app).token }

      parameter name: :website_id, in: :path, type: :string, description: 'Website identifier'
      let(:website_id) { communication_websites(:website_with_github).id }
      parameter name: :id, in: :path, type: :string, description: 'Event identifier'
      let(:id) { communication_website_agenda_events(:test_event).id }

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

      response '404', 'Event not found' do
        let(:id) { 'fake-id' }
        run_test!
      end
    end
  end
end