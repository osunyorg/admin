module Schemas
  class CommunicationWebsite
    def self.schema
      {
        type: :object,
        title: "Communication::Website",
        properties: {
          id: { type: :string },
          name: { type: :string }
        }
      }
    end
  end
end