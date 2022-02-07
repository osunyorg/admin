module Filters
  class User < Base
    def initialize(user)
      super
      add_search
      add :for_role, ::User.roles.keys.map { |r| { to_s: r.humanize, id: r } }, I18n.t('filters.attributes.role')
    end
  end
end
