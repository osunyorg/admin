module Filters
  class Admin::Communication::Extranets < Filters::Base
    def initialize(user)
      super
      add_search
      add :for_about_type,
          ::Communication::Extranet::about_types.compact.map { |r| { to_s: I18n.t("activerecord.attributes.communication/extranet.about_#{r}"), id: r } },
          I18n.t('filters.attributes.kind')
    end
  end
end
