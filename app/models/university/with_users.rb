module University::WithUsers
  extend ActiveSupport::Concern

  included do
    has_many :users, dependent: :destroy

    after_commit :synchronize_server_admin_users, on: :create

    private

    def synchronize_server_admin_users
      User.synchronize_server_admin_users(id)
    end
    handle_asynchronously :synchronize_server_admin_users

  end
end
