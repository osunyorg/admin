module Brevo
  class SmsService
    DEFAULT_SENDER_NAME = 'Osuny'.freeze
    SMS_CREDITS_LIMIT = 500

    def self.send_mfa_code(user, code)
      duration =  ActiveSupport::Duration.build(Rails.application.config.devise.direct_otp_valid_for).inspect
      context = user.registration_context.respond_to?(:to_s_in) ? user.registration_context.to_s_in(user.language)
                                                                : user.registration_context.to_s
      message = I18n.t('sms_code', code: code, context: context, duration: duration)
      self.send_message(user, message)
    end

    def sms_credits
      @sms_credits ||= plan.detect { |plan| plan.type == 'sms' }&.credits
    end

    def low?
      sms_credits.present? && sms_credits < SMS_CREDITS_LIMIT
    end

    private

    def self.send_message(user, message)
      sender_name = user.university.sms_sender_name
      sender_name ||= DEFAULT_SENDER_NAME

      api_instance = Brevo::TransactionalSMSApi.new
      send_transac_sms = Brevo::SendTransacSms.new(
        sender: sender_name,
        recipient: user.mobile_phone,
        content: message
      )

      begin
        # Send SMS message to a mobile number
        result = api_instance.send_transac_sms(send_transac_sms)
        p result
      rescue Brevo::ApiError => e
        puts "Exception when calling TransactionalSMSApi->send_transac_sms: #{e}"
      end
    end

    def plan
      @plan ||= account_api.get_account.plan
    end

    def account_api
      @account_api ||= Brevo::AccountApi.new
    end
  end
end
