require 'swagger_helper'

RSpec.describe 'Osuny API' do
  path '/communication/websites' do
    get 'Lists the websites' do
      tags 'Communication::Website'
      response '200', 'successful operation' do
        schema type: :object, properties: {
          id: {
            type: :string,
            example: '6d8fb0bb-0445-46f0-8954-0e25143e7a58'
          },
          name: {
            type: :string,
            example: 'Site de démo'
          },
          url: {
            type: :string,
            example: 'https://example.osuny.org'
          },
        }
        run_test!
      end
    end
  end
  path '/communication/websites/{id}' do
    get 'Shows a website' do
      tags 'Communication::Website'
      parameter name: :id, in: :path, type: :string,
                description: 'Identifier', example: '6d8fb0bb-0445-46f0-8954-0e25143e7a58'

      let(:id) { '6d8fb0bb-0445-46f0-8954-0e25143e7a58' }
      response '200', 'successful operation' do
        schema type: :object, properties: {
          id: {
            type: :string,
            example: '6d8fb0bb-0445-46f0-8954-0e25143e7a58'
          },
          name: {
            type: :string,
            example: 'Site de démo'
          },
          url: {
            type: :string,
            example: 'https://example.osuny.org'
          },
          deuxfleurs: {
            type: :object,
            title: "Information about Deuxfleurs hosting",
            properties: {
              hosting: {
                type: :boolean,
                example: true
              },
              identifier: {
                type: :string,
                example: 'demo-example'
              }
            }
          },
          features: {
            type: :object,
            title: 'Enabled features',
            properties: {
              agenda: {
                type: :boolean,
                title: 'Agenda (events)',
                example: true
              },
              portfolio: {
                type: :boolean,
                title: 'Portfolio (projects)',
                example: false
              },
              posts: {
                type: :boolean,
                title: 'Posts',
                example: true
              }
            }
          },
          git: {
            type: :object,
            title: 'Information about Git repository',
            properties: {
              branch: {
                type: :string,
                example: 'main'
              },
              endpoint: {
                type: :string,
                title: "Present if different from default provider endpoint",
                example: ''
              },
              provider: {
                type: :string,
                example: 'github'
              },
              repository: {
                type: :string,
                title: 'Repository name with owner',
                example: 'osunyorg/example'
              }
            }
          },
          showcase: {
            type: :object,
            title: 'Information about Osuny showcase',
            properties: {
              present: {
                type: :boolean,
                example: true
              },
              highlighted: {
                type: :boolean,
                example: false
              },
              tags: {
                type: :array,
                items: {
                  type: :array,
                  items: {
                    type: :object,
                    properties: {
                      id: {
                        type: :string,
                        example: '00b85e18-3d4b-4422-811d-a33e99ab6ae3'
                      },
                      name: {
                        type: :string,
                        example: 'Éducation'
                      },
                      slug: {
                        type: :string,
                        example: 'education'
                      }
                    }
                  }
                }
              }
            }
          }
        }
        run_test!
      end
    end
  end
end