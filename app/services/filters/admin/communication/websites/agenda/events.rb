module Filters
  class Admin::Communication::Websites::Agenda::Events < Filters::Base
    def initialize(user, website)
      super(user)
      add_search
      add :for_category,
          website.agenda_categories,
          I18n.t(
            'filters.attributes.element',
            element: Communication::Website::Agenda::Category.model_name.human.downcase
          ),
          false,
          true
    end
  end
end
