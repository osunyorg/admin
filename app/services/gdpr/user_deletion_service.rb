class Gdpr::UserDeletionService
  DAYS_BEFORE_DELETION = 1095
  WARNING_DELAY = 30
  DAYS_BEFORE_WARNING = DAYS_BEFORE_DELETION - WARNING_DELAY

  def handle_users
    alert_users
    delete_users
  end

  private

  def users_to_alert
    @users_to_alert ||= involved_users.where(current_sign_in_at: alert_period)
  end

  def users_to_delete 
    @users_to_delete ||= involved_users.where('current_sign_in_at <= ?', delete_point)
  end

  def involved_users
    User.where.not(role: :server_admin)
  end

  def alert_period
    (Date.today - DAYS_BEFORE_WARNING.days).all_day
  end

  def delete_point
    (Date.today - DAYS_BEFORE_DELETION.days).beginning_of_day
  end

  def alert_users
    users_to_alert.find_each do |user|
      NotificationMailer.gdpr_deletion_incoming(user.university, user).deliver_later
    end
  end

  def delete_users
    users_to_delete.find_each do |user|
      # Nullification du user des personnes, même si elles sont dans la corbeille
      University::Person.with_deleted
                        .where(user_id: user.id)
                        .update_all(user_id: nil)
      user.destroy
    end
  end

end