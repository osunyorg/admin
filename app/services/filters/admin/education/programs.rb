module Filters
  class Admin::Education::Programs < Filters::Base
    def initialize(user)
      super
      add_search
      add :for_diploma,
          user.university.education_diplomas,
          I18n.t(
            'filters.attributes.element',
            element: Education::Diploma.model_name.human.downcase
          )
    end
  end
end
