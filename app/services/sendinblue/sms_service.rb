module Sendinblue
  class SmsService
    DEFAULT_SENDER_NAME = 'Osuny'.freeze

    def self.send_mfa_code(user, code)
      duration =  ActiveSupport::Duration.build(Rails.application.config.devise.direct_otp_valid_for).inspect
      message = "#{code} est votre code d'authentification sur #{user.university} (valide #{duration})"
      self.send_message(user, message)
    end

    private

    def self.send_message(user, message)
      sender_name = user.university.sms_sender_name
      sender_name ||= DEFAULT_SENDER_NAME

      api_instance = SibApiV3Sdk::TransactionalSMSApi.new
      send_transac_sms = SibApiV3Sdk::SendTransacSms.new(
        sender: sender_name,
        recipient: user.mobile_phone,
        content: message
      )

      begin
        # Send SMS message to a mobile number
        result = api_instance.send_transac_sms(send_transac_sms)
        p result
      rescue SibApiV3Sdk::ApiError => e
        puts "Exception when calling TransactionalSMSApi->send_transac_sms: #{e}"
      end
    end
  end
end