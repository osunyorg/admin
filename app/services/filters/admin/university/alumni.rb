module Filters
  class Admin::University::Alumni < Filters::Base
    def initialize(user)
      super
      add_search
      add :for_alumni_program,
          user.university.education_programs,
          I18n.t(
            'filters.attributes.element',
            element: Education::Program.model_name.human.downcase
          ),
          false,
          true
      add :for_alumni_year,
          user.university.academic_years.ordered,
          I18n.t(
            'filters.attributes.element',
            element: Education::AcademicYear.model_name.human.downcase
          )
    end
  end
end
