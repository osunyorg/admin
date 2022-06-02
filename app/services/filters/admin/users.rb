module Filters
  class Admin::Users < Filters::Base
    def initialize(user)
      super
      add_search
      add :for_language,
          ::Language.all.map { |l| { to_s: I18n.t("languages.#{l.iso_code}"), id: l.id } },
          I18n.t(
            'filters.attributes.element',
            element: Language.model_name.human.downcase
          )
      add :for_role,
          ::User.roles.keys.map { |r| { to_s: I18n.t("activerecord.attributes.user.roles.#{r}"), id: r } },
          I18n.t('filters.attributes.role')
    end
  end
end
