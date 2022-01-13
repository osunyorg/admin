class SyncServerAdminUsersJob < ApplicationJob
  queue_as :default

  def perform(source_university_id, target_university_id)
    source_university = University.find_by(id: source_university_id)
    target_university = University.find_by(id: target_university_id)
    return unless source_university.present? && target_university.present?
    User.synchronize_server_admin_users(source_university, target_university)
  end
end
