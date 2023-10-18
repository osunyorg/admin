module User::WithSyncBetweenUniversities
  extend ActiveSupport::Concern

  included do
    attr_accessor :skip_server_admin_sync

    after_save :sync_between_universities, if: Proc.new { |user| user.server_admin? && !user.skip_server_admin_sync }
    after_destroy :remove_from_all_universities, if: Proc.new { |user| user.server_admin? }

    def self.synchronize_server_admin_users(source_university, target_university)
      source_university.users.server_admin.each do |user|
        user.sync_in_university(target_university)
      end
    end
  end

  def sync_between_universities
    University.where.not(id: university_id).each do |target_university|
      sync_in_university(target_university)
    end
  end

  def sync_in_university(target_university)
    unless User.where(email: email, university_id: target_university.id).any?
      duplicate_user_for_university(target_university)
    else
      User.find_by(email: email, university_id: target_university.id)&.update_columns(
        encrypted_password: self.encrypted_password,
        first_name: self.first_name,
        last_name: self.last_name,
        mobile_phone: self.mobile_phone,
        role: :server_admin
      )
    end
  end

  private

  def duplicate_user_for_university(target_university)
    # Create user for this university
    user = self.dup
    user.assign_attributes(university_id: target_university.id, picture_infos: nil,
                            password: "MyNewPasswordIs2Strong!", password_confirmation: "MyNewPasswordIs2Strong!",
                            reset_password_token: nil, unlock_token: nil, encrypted_otp_secret_key: nil,
                            confirmation_token: Devise.friendly_token, confirmed_at: Time.now,
                            role: :server_admin, skip_server_admin_sync: true)
    # as a new user must have a password and we can't access previous user password
    user.save
    user.update_column(:encrypted_password, self.encrypted_password) if user.valid?
  end

  def remove_from_all_universities
    # As a "server_admin" is synced between universities, any removal destroys the accounts of the concerned user in every university
    User.where(email: email, role: :server_admin).destroy_all
  end

end
