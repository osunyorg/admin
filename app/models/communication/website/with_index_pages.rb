module Communication::Website::WithIndexPages
  extend ActiveSupport::Concern

  included do
    has_many :index_pages,
             class_name: 'Communication::Website::IndexPage',
             foreign_key: :communication_website_id,
             dependent: :destroy

    def index_for(kind)
      index_pages.where(kind: kind).first_or_initialize(
        title: I18n.t("communication.website.index_pages.default.#{kind}.title"),
        path: I18n.t("communication.website.index_pages.default.#{kind}.path"),
        description: I18n.t("communication.website.index_pages.default.#{kind}.description")
      )
    end
  end

end
