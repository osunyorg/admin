module Schemas
  class CommunicationWebsiteLocalization
    def self.schema
      {
        type: :object,
        title: "Communication::Website::Localization",
        properties: {
          id: { type: :string },
          name: { type: :string },
          published: { type: :boolean },
          published_at: { type: :string, format: "date-time", nullable: true },
          social_email: { type: :string, nullable: true },
          social_facebook: { type: :string, nullable: true },
          social_github: { type: :string, nullable: true },
          social_instagram: { type: :string, nullable: true },
          social_linkedin: { type: :string, nullable: true },
          social_mastodon: { type: :string, nullable: true },
          social_peertube: { type: :string, nullable: true },
          social_tiktok: { type: :string, nullable: true },
          social_vimeo: { type: :string, nullable: true },
          social_x: { type: :string, nullable: true },
          social_youtube: { type: :string, nullable: true },
          created_at: { type: :string, format: "date-time" },
          updated_at: { type: :string, format: "date-time" }
        }
      }
    end
  end
end