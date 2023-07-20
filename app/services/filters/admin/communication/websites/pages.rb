module Filters
  class Admin::Communication::Websites::Pages < Filters::Base
    def initialize(user)
      super(user)
      add_search
      add :for_published,
          [{ to_s: I18n.t('true'), id: 'true' }, { to_s: I18n.t('false'), id: 'false' }],
          I18n.t(
            'filters.attributes.element',
            element: I18n.t('admin.communication.website.pages.published_status').downcase
          )
      add :for_full_width,
          [{ to_s: I18n.t('true'), id: 'true' }, { to_s: I18n.t('false'), id: 'false' }],
          I18n.t(
            'filters.attributes.element',
            element: I18n.t('admin.communication.website.pages.full_width_status').downcase
          )
    end
  end
end
