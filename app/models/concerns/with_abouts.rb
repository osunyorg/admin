module WithAbouts
  extend ActiveSupport::Concern

  included do
    belongs_to  :about,
                polymorphic: true,
                optional: true

    before_validation :nullify_about_id_if_about_type_changed_to_blank

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

  protected

  def nullify_about_id_if_about_type_changed_to_blank
    self.about_id = nil if about_type_changed? && about_type.blank?
  end
end
