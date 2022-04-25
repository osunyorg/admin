module Filters
  class Admin::University::People < Filters::Base
    def initialize(user)
      super
      add_search
      add :for_role, ::University::Person::LIST_OF_ROLES.map { |r| { to_s: I18n.t("activerecord.attributes.university/person.#{r}"), id: r } }, I18n.t('filters.attributes.role')
    end
  end
end
