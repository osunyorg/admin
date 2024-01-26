module Education::Program::WithLocations
  extend ActiveSupport::Concern

  included do
    has_and_belongs_to_many :locations,
                            class_name: 'Administration::Location',
                            foreign_key: :administration_location_id,
                            association_foreign_key: :education_program_id
  end
end
