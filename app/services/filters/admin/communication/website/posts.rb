module Filters
  class Admin::Communication::Website::Posts < Filters::Base
    def initialize(user, website)
      super(user)
      add_search
      add :for_author, website.authors.ordered, I18n.t('filters.attributes.element', element: I18n.t('activerecord.attributes.communication/website/post.author').downcase)
      add :for_category, website.categories, I18n.t('filters.attributes.element', element: I18n.t('activerecord.models.communication/website/category.one').downcase), false, true

    end
  end
end
