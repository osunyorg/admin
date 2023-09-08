module Communication::Website::WithManagers
  extend ActiveSupport::Concern

  included do
    has_and_belongs_to_many :managers,
                            class_name: 'User',
                            join_table: :communication_websites_users,
                            foreign_key: :communication_website_id,
                            association_foreign_key: :user_id
  end
end
