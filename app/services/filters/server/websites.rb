module Filters
  class Server::Websites < Filters::Base
    def initialize(user)
      super
      add_search
      add :for_theme_version,
          ::Communication::Website.all.pluck(:theme_version).uniq.sort,
          I18n.t(
            'filters.attributes.element',
            element: I18n.t('server_admin.websites.theme_version').downcase
          )
          add :for_production,
          [
            { to_s: I18n.t('true'), id: 'true' }, 
            { to_s: I18n.t('false'), id: 'false' }
          ],
          I18n.t(
            'filters.attributes.element',
            element: I18n.t('server_admin.websites.production_status').downcase
          )
      add :for_update,
          [
            { to_s: I18n.t('server_admin.websites.autoupdate_theme.true'), id: 'true' }, 
            { to_s:  I18n.t('server_admin.websites.autoupdate_theme.false'), id: 'false' }
          ],
          I18n.t(
            'filters.attributes.element',
            element: I18n.t('server_admin.websites.update_mode').downcase
          )
      add :for_updatable_theme,
          [
            { to_s: I18n.t('server_admin.websites.updatable_theme_filter.value'), id: 'true' }
          ],
          I18n.t(
            'filters.attributes.element',
            element: I18n.t('server_admin.websites.updatable_theme_filter.element').downcase
          )

    end
  end
end
