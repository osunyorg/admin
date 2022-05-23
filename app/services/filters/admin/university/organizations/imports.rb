module Filters
  class Admin::University::Organizations::Imports < Filters::Base
    def initialize(user)
      super
      add :for_status,
          ::Import::statuses.keys.map { |r| { to_s: I18n.t("enums.import.status.#{r}"), id: r } },
          I18n.t(
            'filters.attributes.element',
            element: Import.human_attribute_name('status').downcase
          )
    end
  end
end
