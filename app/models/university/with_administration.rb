module University::WithAdministration
  extend ActiveSupport::Concern

  included do
    has_many  :administration_locations,
              class_name: 'Administration::Location',
              dependent: :destroy
    alias_method :locations, :administration_locations
  end
end
