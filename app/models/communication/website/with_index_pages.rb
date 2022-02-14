module Communication::Website::WithIndexPages
  extend ActiveSupport::Concern

  included do
    has_many :index_pages,
             class_name: 'Communication::Website::IndexPage',
             foreign_key: :communication_website_id,
             dependent: :destroy
  end

end
