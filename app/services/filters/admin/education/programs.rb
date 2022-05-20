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
      add :for_school,
          user.university.education_schools,
          I18n.t(
            'filters.attributes.element',
            element: Education::School.model_name.human.downcase
          )
      add :for_publication,
          [
            { to_s: I18n.t('true'), id: 'true' },
            { to_s: I18n.t('false'), id: 'false' }
          ],
          I18n.t(
            'filters.attributes.element',
            element: I18n.t('admin.education.programs.publication').downcase
          )
    end
  end
end
