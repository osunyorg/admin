module University::WithUsers
  extend ActiveSupport::Concern

  included do
    attr_accessor :source_university_id

    has_many :users, dependent: :destroy

    after_commit :synchronize_server_admin_users, on: :create

    private

    def synchronize_server_admin_users
      return unless source_university_id.present?
      SyncServerAdminUsersJob.perform_later(source_university_id, id)
    end
  end
end
