module Filters
  class Admin::University::Organizations < Filters::Base
    def initialize(user)
      super
      add_search
      add :for_kind,
          ::University::Organization::kinds.keys.map { |r| { to_s: I18n.t("enums.university.organization.kind.#{r}"), id: r } },
          I18n.t('filters.attributes.kind')
    end
  end
end
