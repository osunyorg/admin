module University::Person::WithExperiences
  extend ActiveSupport::Concern

  included do

    has_many                      :experiences,
                                  class_name: "University::Person::Experience",
                                  dependent: :destroy

    accepts_nested_attributes_for :experiences,
                                  reject_if: :all_blank,
                                  allow_destroy: true

    validates_associated :experiences

    scope :for_alumni_organization, -> (organization_id) {
      left_joins(:experiences)
        .where(university_person_experiences: { organization_id: organization_id })
        .select("university_people.*")
        .distinct
    }

  end

end
