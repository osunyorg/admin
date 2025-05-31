# frozen_string_literal: true
module Communication::Website::WithFederations
  extend ActiveSupport::Concern

  included do
    has_and_belongs_to_many :source_websites,
                            join_table: :communication_website_federations,
                            foreign_key: :destination_website_id,
                            association_foreign_key: :source_website_id,
                            class_name: 'Communication::Website'
    has_and_belongs_to_many :destination_websites,
                            join_table: :communication_website_federations,
                            foreign_key: :source_website_id,
                            association_foreign_key: :destination_website_id,
                            class_name: 'Communication::Website'
  end
end