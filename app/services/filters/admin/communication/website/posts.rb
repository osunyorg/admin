module Filters
  class Admin::Communication::Website::Posts < Filters::Base
    def initialize(user, website, language)
      super(user)
      add_search
      add :for_author,
          website.authors.ordered(language),
          I18n.t(
            'filters.attributes.element',
            element: I18n.t('activerecord.attributes.communication/website/post.author').downcase
          )
      add :for_category,
          website.post_categories.for_language(language),
          I18n.t(
            'filters.attributes.element',
            element: Communication::Website::Post::Category.model_name.human.downcase
          ),
          false,
          true
      add :for_pinned,
          [{ to_s: I18n.t('true'), id: 'true' }, { to_s: I18n.t('false'), id: 'false' }],
          I18n.t(
            'filters.attributes.element',
            element: I18n.t('admin.communication.website.post.localizations.pinned_status').downcase
          )
    end
  end
end
