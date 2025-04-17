module User::WithAuthentication
  extend ActiveSupport::Concern

  included do
    devise  :database_authenticatable, :registerable, :recoverable, :rememberable,
            :timeoutable, :confirmable, :trackable, :lockable, :two_factor_authenticatable, :omniauthable, omniauth_providers: [:saml]
            # note : i do not use :validatable because of the non-uniqueness of the email. :validatable is replaced by the validation sequences below

    has_one_time_password(encrypted: true)

    validates :role, :last_name, :email, presence: true

    validates :email, 
              uniqueness: { scope: :university_id }, 
              allow_blank: true, 
              if: :will_save_change_to_email?
    validates :email, 
              format: { with: Devise::email_regexp }, 
              allow_blank: true, 
              if: :will_save_change_to_email?
    validates :password, presence: true, if: :password_required?
    validates :password, confirmation: true, if: :password_required?
    validate :password_complexity
    validates :mobile_phone, format: { with: /\A\+[0-9]+\z/ }, allow_blank: true

    before_validation :adjust_mobile_phone, :sanitize_fields

    def self.find_for_authentication(warden_conditions)
      where(email: warden_conditions[:email].downcase, university_id: warden_conditions[:university_id]).first
    end

    def self.send_confirmation_instructions(attributes = {})
      confirmable = find_by_unconfirmed_email_with_errors(attributes) if reconfirmable
      unless confirmable.try(:persisted?)
        confirmable = find_or_initialize_with_errors(confirmation_keys, attributes, :not_found)
      end
      confirmable.registration_context = attributes[:registration_context] if attributes.has_key?(:registration_context)
      confirmable.resend_confirmation_instructions if confirmable.persisted?
      confirmable
    end

    def self.send_unlock_instructions(attributes = {})
      lockable = find_or_initialize_with_errors(unlock_keys, attributes, :not_found)
      lockable.registration_context = attributes[:registration_context] if attributes.has_key?(:registration_context)
      lockable.resend_unlock_instructions if lockable.persisted?
      lockable
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

    def send_new_otp(request, options = {})
      current_extranet = Communication::Extranet.with_host(request.host)
      current_university = University.with_host(request.host)
      current_university ||= university
      self.registration_context = current_extranet || current_university
      super
    end

    def direct_otp_default_delivery_method
      mobile_phone.present? ? :mobile_phone : :email
    end

    def send_two_factor_authentication_code(code, delivery_method)
      case delivery_method
      when :mobile_phone
        Brevo::SmsService.send_mfa_code(self, code)
      when :email
        send_devise_notification(:two_factor_authentication_code, code, {})
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
      if self.mobile_phone.start_with?('+330')
        self.mobile_phone = "+33#{self.mobile_phone[4..-1]}"
      end
    end

    def sanitize_fields
      # Only text allowed, and remove '=' to prevent excel formulas
      self.email = Osuny::Sanitizer.sanitize(self.email, 'string')&.gsub('=', '')
      self.first_name = Osuny::Sanitizer.sanitize(self.first_name, 'string')&.gsub('=', '')
      self.last_name = Osuny::Sanitizer.sanitize(self.last_name, 'string')&.gsub('=', '')
      self.mobile_phone = Osuny::Sanitizer.sanitize(self.mobile_phone, 'string')&.gsub('=', '')
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
