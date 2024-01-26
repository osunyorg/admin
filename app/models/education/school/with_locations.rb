module Education::School::WithLocations
  extend ActiveSupport::Concern

  included do
    has_and_belongs_to_many :locations,
                            class_name: 'Administration::Location',
                            foreign_key: :administration_location_id,
                            association_foreign_key: :education_school_id
  end
end
