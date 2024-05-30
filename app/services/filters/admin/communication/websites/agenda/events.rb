module Filters
  class Admin::Communication::Websites::Agenda::Events < Filters::Base
    def initialize(user, website, language)
      super(user)
      add_search
      add :for_category,
          website.agenda_categories.for_language(language),
          I18n.t(
            'filters.attributes.element',
            element: Communication::Website::Agenda::Category.model_name.human.downcase
          ),
          false,
          true
    end
  end
end
