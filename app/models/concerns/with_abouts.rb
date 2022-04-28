module WithAbouts
  extend ActiveSupport::Concern

  included do
    belongs_to  :about,
                polymorphic: true,
                optional: true

    scope :for_about_type, -> (type) { where(about_type: type) }

    def self.about_types
      [
        nil,
        Education::School.name,
        Education::Program.name,
        Research::Laboratory.name,
        Research::Journal.name,
      ]
    end

  end
end
