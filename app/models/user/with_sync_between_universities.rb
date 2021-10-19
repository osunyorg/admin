module User::WithSyncBetweenUniversities
  extend ActiveSupport::Concern

  included do
    after_save :sync_from_current_university, if: Proc.new { |user| user.server_admin? }

    def self.synchronize_server_admin_users(university_id)
      university = University.where.not(id: university_id).first
      university.users.server_admin.each(&:sync_from_current_university) if university
    end
  end

  def sync_from_current_university
    University.where.not(id: university_id).each do |university|
      unless User.where(email: email, university_id: university.id).any?
        duplicate_user_for_university(university)
      else
        User.where(email: email, university_id: university.id).first&.update_columns(
          encrypted_password: self.encrypted_password,
          first_name: self.first_name,
          last_name: self.last_name,
          mobile_phone: self.mobile_phone,
          role: self.role
        )
      end
    end
  end

  private

  def duplicate_user_for_university(university)
    # Create user for this university
    user = self.dup
    user.assign_attributes(university_id: university.id, picture_infos: nil,
                            password: "MyNewPasswordIs2Strong!", password_confirmation: "MyNewPasswordIs2Strong!",
                            reset_password_token: nil, unlock_token: nil, encrypted_otp_secret_key: nil,
                            confirmation_token: Devise.friendly_token, confirmed_at: Time.now)
    # as a new user must have a password and we can't access previous user password
    user.save
    user.update_column(:encrypted_password, self.encrypted_password) if user.valid?
  end

end
