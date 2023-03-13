module Filters
  class Admin::University::Organizations < Filters::Base
    def initialize(user)
      super
      add_search
      if user.university.organizations_categories.any?
        add :for_category,
            user.university.organizations_categories.ordered,
            I18n.t('filters.attributes.category')
      end
      add :for_kind,
          ::University::Organization::kinds.keys.map { |r| { to_s: I18n.t("enums.university.organization.kind.#{r}"), id: r } },
          I18n.t('filters.attributes.kind')
    end
  end
end
