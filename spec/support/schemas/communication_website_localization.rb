module Schemas
  class CommunicationWebsiteLocalization
    def self.schema
      {
        type: :object,
        title: "Communication::Website::Localization",
        properties: {
          id: { type: :string },
          name: { type: :string }
        }
      }
    end
  end
end