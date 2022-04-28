module Filters
  class Admin::Communication::Websites < Filters::Base
    def initialize(user)
      super
      add_search
      add :for_about_type, ::Communication::Website::about_types.compact.map { |r| { to_s: I18n.t("activerecord.attributes.communication/website.about_#{r}"), id: r } }, I18n.t('filters.attributes.kind')
    end
  end
end
