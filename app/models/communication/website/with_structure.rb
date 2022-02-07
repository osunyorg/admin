module Communication::Website::WithStructure
  extend ActiveSupport::Concern

  included do
    has_one :structure,
            class_name: 'Communication::Website::Structure',
            foreign_key: :communication_website_id,
            dependent: :destroy

    after_create :create_structure
  end

  protected

  def create_structure
    build_structure(university_id: university_id).save
  end
end
