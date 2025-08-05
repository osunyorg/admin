module Communication::Website::WithRealmCommunication
  extend ActiveSupport::Concern

  included do
    has_many    :permalinks,
                class_name: "Communication::Website::Permalink",
                dependent: :destroy

    has_many    :communication_blocks,
                class_name: "Communication::Block",
                foreign_key: :communication_website_id
    alias       :blocks :communication_blocks
  end

end