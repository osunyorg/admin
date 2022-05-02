module User::WithAuthentication
  extend ActiveSupport::Concern

  included do
    devise  :database_authenticatable, :registerable, :recoverable, :rememberable,
            :timeoutable, :confirmable, :trackable, :lockable, :two_factor_authenticatable, :omniauthable, omniauth_providers: [:saml]
            # note : i do not use :validatable because of the non-uniqueness of the email. :validatable is replaced by the validation sequences below


    has_one_time_password(encrypted: true)

    validates :role, presence: true

    validates_presence_of :first_name, :last_name, :email
    validates_uniqueness_of :email, scope: :university_id, allow_blank: true, if: :will_save_change_to_email?
    validates_format_of :email, with: Devise::email_regexp, allow_blank: true, if: :will_save_change_to_email?
    validates_presence_of :password, if: :password_required?
    validates_confirmation_of :password, if: :password_required?
    validate :password_complexity
    validates :mobile_phone, format: { with: /\A\+[0-9]+\z/ }, allow_blank: true

    before_validation :adjust_mobile_phone, :sanitize_fields

    def self.find_for_authentication(warden_conditions)
      where(email: warden_conditions[:email].downcase, university_id: warden_conditions[:university_id]).first
    end

    # Inject a session_token in user salt to prevent Cookie session hijacking
    # https://makandracards.com/makandra/53562-devise-invalidating-all-sessions-for-a-user
    def authenticatable_salt
      "#{super}#{session_token}"
    end

    def invalidate_all_sessions!
      self.session_token = SecureRandom.hex
    end

    def need_two_factor_authentication?(request)
      true
    end

    def send_two_factor_authentication_code(code, options = {})
      if mobile_phone.blank? || options.dig(:delivery_method) == :email
        send_devise_notification(:two_factor_authentication_code, code, {})
      else
        Sendinblue::SmsService.send_mfa_code(self, code)
      end
    end

    def unlock_mfa!
      self.update_column(:second_factor_attempts_count, 0)
    end

    private

    def adjust_mobile_phone
      return if self.mobile_phone.nil?
      self.mobile_phone = self.mobile_phone.delete(' ')
      if self.mobile_phone.start_with?('06', '07')
        self.mobile_phone = "+33#{self.mobile_phone[1..-1]}"
      end
    end

    def sanitize_fields
      full_sanitizer = Rails::Html::FullSanitizer.new

      # Only text allowed, and remove '=' to prevent excel formulas
      self.email = full_sanitizer.sanitize(self.email)&.gsub('=', '')
      self.first_name = full_sanitizer.sanitize(self.first_name)&.gsub('=', '')
      self.last_name = full_sanitizer.sanitize(self.last_name)&.gsub('=', '')
      self.mobile_phone = full_sanitizer.sanitize(self.mobile_phone)&.gsub('=', '')
    end

    def password_required?
      !persisted? || !password.nil? || !password_confirmation.nil?
    end

    def password_complexity
      # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
      return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#{Rails.application.config.allowed_special_chars}]).{#{Devise.password_length.first},#{Devise.password_length.last}}$/
      errors.add :password, :password_strength
    end
  end
end
