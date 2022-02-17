module Communication::Website::WithIndexPages
  extend ActiveSupport::Concern

  included do
    has_many :index_pages,
             class_name: 'Communication::Website::IndexPage',
             foreign_key: :communication_website_id,
             dependent: :destroy

    def index_for(kind)
      klass = "Communication::Website::IndexPage::#{kind.to_s.camelize}".constantize
      key = "communication.website.index_pages.default.#{kind.to_s}"
      klass.where(communication_website_id: id, kind: kind).first_or_create(
        title: I18n.t("#{key}.title"),
        path: I18n.t("#{key}.path"),
        description: I18n.t("#{key}.description")
      )
    end
  end

end
