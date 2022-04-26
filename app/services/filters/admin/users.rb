module Filters
  class Admin::Users < Filters::Base
    def initialize(user)
      super
      add_search
      add :for_role, ::User.roles.keys.map { |r| { to_s: I18n.t("activerecord.attributes.user.roles.#{r}"), id: r } }, I18n.t('filters.attributes.role')
    end
  end
end
