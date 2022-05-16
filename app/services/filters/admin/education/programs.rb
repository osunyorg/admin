module Filters
  class Admin::Education::Programs < Filters::Base
    def initialize(user)
      super
      add_search
      add :for_diploma,
          user.university.education_diplomas,
          I18n.t(
            'filters.attributes.element',
            element: I18n.t('activerecord.models.education/diploma.one').downcase
          ),
          false,
          false
    end
  end
end
