module Filters
  class Admin::Education::Teachers < Filters::Base
    def initialize(user)
      super
      add_search
      add :for_program,
          user.university.education_programs,
          I18n.t(
            'filters.attributes.element',
            element: Education::Program.model_name.human.downcase
          ),
          false,
          true
    end
  end
end
