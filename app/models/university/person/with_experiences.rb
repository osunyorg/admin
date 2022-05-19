module University::Person::WithExperiences
  extend ActiveSupport::Concern

  included do

    has_many                      :experiences,
                                  class_name: "University::Person::Experience"

    accepts_nested_attributes_for :experiences,
                                  reject_if: :all_blank,
                                  allow_destroy: true

    validates_associated :experiences

  end

end
