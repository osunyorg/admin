module Communication::Website::Permalink::WithOpenApi
  extend ActiveSupport::Concern

  included do
    OPENAPI_SCHEMA = {
      type: :object,
      title: "Communication::Website::Permalink",
      properties: {
        id: { type: :string, format: :uuid },
        path: { type: :string }
      }
    }
  end

end
