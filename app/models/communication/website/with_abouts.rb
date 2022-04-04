module Communication::Website::WithAbouts
  extend ActiveSupport::Concern

  included do
    belongs_to  :about,
                polymorphic: true,
                optional: true

    def self.about_types
      [
        nil,
        Education::School.name,
        Research::Laboratory.name,
        Research::Journal.name
      ]
    end

  end
end
