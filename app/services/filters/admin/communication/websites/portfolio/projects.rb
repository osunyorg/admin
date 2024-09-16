module Filters
  class Admin::Communication::Websites::Portfolio::Projects < Filters::Base
    def initialize(user, website, language)
      super(user)
      add_search
      add :for_category,
          website.projects_categories.tmp_original,
          I18n.t(
            'filters.attributes.element',
            element: Communication::Website::Portfolio::Category.model_name.human.downcase
          ),
          false,
          true
    end
  end
end
